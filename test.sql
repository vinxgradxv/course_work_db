--triggers
insert into task(start_date, end_date, complexity, productivity_statistics_id) values
        ('2023-10-31', '2023-10-01', 75, 1);

insert into work_time(start_timestamp, end_timestamp, employee_id) VALUES
        ('2023-10-31 18:05:06', '2023-10-31 17:05:06', 2);

insert into task(start_date, end_date, complexity, productivity_statistics_id) values
        ('2023-10-01', '2023-10-31', 12, 1);

insert into employee(name, age, division, admin_id) VALUES
        ('Денис Белов', 20, 'Отдел перевода стрелок', (select id from admin a where a.name='Кабан Кабаныч')),
        ('Игорь Проничев', 20, 'Отдел перевода стрелок', (select id from admin a where a.name='Кабан Кабаныч')),
        ('Дарина Демидова', 21, 'Отдел перевода стрелок', (select id from admin a where a.name='Кабан Кабаныч'));
        --('Ира Легкова', 20, 'Отдел перекров', (select id from admin a where a.name='Кабан Кабаныч'));

insert into food_compensation(payment_amount, compensation_date, is_breakfast, employee_id) VALUES
    (40000, '2023-09-20', false, 3);

insert into dayoff_request(start_date, end_date, employee_id) VALUES
        ('2023-10-01', '2023-10-03', 1);

--functions
-- не получается проверить, ругается на возвращаемое значение
DO $$
DECLARE
    SUM integer;
BEGIN
    SELECT get_compensation_sum('2023-09-20', '2023-09-20', 3) into SUM;
END $$;


DO $$
BEGIN
    CALL give_equipment_to_team('Отдел перевода стрелок', 1, '2023-12-20', '2023-12-31');
END $$;

DO $$
BEGIN
    CALL assign_course_to_team('Отдел перевода стрелок', 1);
END $$;

DO $$
BEGIN
    CALL hire_employee('Виталий Громыко', null, 33, 1);
END $$;

DO $$
BEGIN
    CALL fire_employee(1);
END $$;


--вроде работает, но отображается только в селекте
DO $$
BEGIN
    insert into task(start_date, end_date, complexity, productivity_statistics_id) values
        ('2023-08-01', '2023-08-28', 75, 1);
    insert into food_compensation(payment_amount, compensation_date, is_breakfast, employee_id) VALUES
    (40000, '2023-09-20', true, 1);
    CALL cancel_food_compensation_for_deadline_miss(1);
END $$;

select * from food_compensation fc where fc.employee_id=1
        and (select min(task.end_date) from task where task.productivity_statistics_id = (select max(id) from productivity_statistics ps where ps.employee_id=1)
        and task.end_date < CURRENT_DATE and task.status != 'Done') < fc.compensation_date;

select * from food_compensation;






