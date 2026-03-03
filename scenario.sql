use gym_management

-- 1 . Show all active members

select * from members where status ="active"

-- 2 . Count total members in the gym.

select count(*) from members

-- 3. List all membership plans sorted by price

select * from membership_plans order by price desc

-- 4 . Show members who joined after 2023-01-01

select * from members where join_date >= "2023-01-01"

-- 5 .Count total trainers.

select count(*) from trainers

-- 6 . Show all unpaid invoices

select * from invoices where status = "unpaid"

-- 7 . Show total number of workout plans available.

select count(*) as total_workoutplans from workout_plans 

-- 8  Find members whose membership expires this month.

select * from member_memberships where end_date between '2024-03-01' and '2024-04-01'


--  9 Show last 10 payments made

select * from payments order by payment_date desc limit 10

-- 10 . Count total attendance records

select count(*) as total_attendance from attendance    




-- 11  Show member name with their current plan name.

select m.m_name , mp.plan_name from member_memberships mm join members m on mm.member_id = m.member_id
join membership_plans mp on mm.plan_id = mp.plan_id
where mm.start_date=(
	select max(start_date)
    from member_memberships
    where member_id = mm.member_id
)

-- 12 Show total revenue generated so far

select
(select sum(amount) from payments) -
(select sum(refund_amount) from refunds) as net_revenue


-- 13 Find members who never attended the gym

select m.member_id , m.m_name from members m left join attendance a on m.member_id = a.member_id where a.member_id IS NULL

select m.member_id, m.m_name from members m where not exists(select 1 from attendance a where m.member_id = a.member_id)



-- 14 Show top 5 members by attendance count.

select m.m_name ,a.member_id,count(*) as a_count  from members m join  attendance a on m.member_id = a.member_id 
group by m.m_name , a.member_id order by a_count desc limit 5

-- 15 Show trainer name with number of members assigned to them.

select t.trainer_id ,t.t_name , count(mt.member_id) as mcount from  member_trainers mt 
join trainers t on mt.trainer_id = t.trainer_id
group by t.trainer_id ,t.t_name

-- 16. Show invoice status summary (paid, unpaid, partial count).

select status, count(*) from invoices group by status


-- 17 . Find members with pending balance (invoice amount > payments).

select m.m_name, mm.membership_id,sum(p.amount)as t_amount, i.total_amount,'Pending' as status from members m join member_memberships mm on mm.member_id = m.member_id
left join payments p on p.membership_id = mm.membership_id join invoices i on p.membership_id = i.membership_id 
group by m.m_name, mm.membership_id, i.total_amount having i.total_amount > t_amount 

-- 18 . Show monthly revenue report (group by month)

select year(payment_date) as year, month(payment_date) as month ,sum(amount) as month_revenue from payments
group by year(payment_date),month(payment_date) order by year(payment_date),month(payment_date) asc

-- 19 Show members who received refunds.

select m.m_name ,r.payment_id,r.refund_amount from 
members m join member_memberships mm on m.member_id = mm.member_id 
join payments p  on p.membership_id = mm.membership_id 
join refunds r on  p.payment_id = r.payment_id

-- 20 Show total refund amount given
select sum(refund_amount) as total_refund_amount from refunds

-- 21 Show average payment amount

select avg(amount) from payments

-- 22 Show highest paying member

select m.m_name ,p.amount from members m join member_memberships mm on m.member_id = mm.membership_id
join payments p on p.membership_id = mm.membership_id order by p.amount desc limit 1

-- 23 Show plan-wise revenue
select mp.plan_name , sum(mm.plan_price) as total_revenue from membership_plans mp
join member_memberships mm on mp.plan_id = mm.plan_id
group by mp.plan_name

-- 24 Show top 3 most profitable membership plans.
select mp.plan_name , sum(mm.plan_price) as total_revenue from membership_plans mp
join member_memberships mm on mp.plan_id = mm.plan_id
group by mp.plan_name order by total_revenue limit 3

-- 25 Show members whose payment is partially completed
select m.m_name ,i.total_amount,i.status from members m join member_memberships mm 
on m.member_id = mm.member_id join invoices i on i.membership_id = mm.membership_id having status = 'partial'

-- 26 Show average attendance per member

select m.m_name , avg(a.member_id) from members m join attendance a on m.member_id = a.member_id
group by m.m_name


-- 27 Rank members by total payments (use window function)
select 
member_id, m_name,total_payment,
rank() over (order by (total_payment) desc) as payment_rank
from(
select m.member_id,m.m_name, sum(p.amount) as total_payment from members m join member_memberships mm  on m.member_id = mm.member_id
join payments p on p.membership_id = mm.membership_id group by m.member_id , m.m_name
) as payment_summary

-- 28  Show trainers who were hired before 2022
select * from trainers where hire_date < '2022-01-01'

-- 29 Show total number of members per membership plan

select mp.plan_name,count(mm.member_id) as total_no_members from membership_plans mp 
join member_memberships mm on mp.plan_id = mm.plan_id
group by mp.plan_name

-- 30 Show total revenue collected per payment method
select payment_method ,sum(amount) as total_revenue from payments group by payment_method