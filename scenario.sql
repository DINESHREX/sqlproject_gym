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