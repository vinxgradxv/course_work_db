insert into course(name, description, category)
values ('Как бороться с храсментом', 'Описание правил поведения на рабочеем месте', 'soft skills'),
       ('Программирование на brainfuck для чайников', 'Пособие по программированию на набирающем популярность языке', 'hard skills');

insert into enterprise_equipment(type, serial_number, description) VALUES
        ('Ноутбук', 123123, 'Ноутбку для выполнения рабочих задач'),
        ('Ноутбук', 123124, 'Ноутбку для выполнения рабочих задач'),
        ('Проектор', 1, 'Для проведения встреч и презентаций');

insert into admin(name, age, division) values
        ('Кабан Кабаныч', 54, 'Совет правления');

insert into employee(name, age, division, admin_id) VALUES
        ('Владислав Трофимченко', 20, 'Отдел перевода стрелок', (select id from admin a where a.name='Кабан Кабаныч')),
        ('Глеб Виноградов', 20, 'Отдел перекуров', (select id from admin a where a.name='Кабан Кабаныч')),
        ('Екатерина Неделькович', 19, 'Отдел перевода стрелок', (select id from admin a where a.name='Кабан Кабаныч'));

insert into work_time(start_timestamp, end_timestamp, employee_id) VALUES
        ('2023-09-30 08:05:06', '2023-09-30 17:05:06', 2);

insert into dayoff_request(start_date, end_date, employee_id) VALUES
        ('2023-09-01', '2023-09-03', 1),
        ('2023-09-04', '2023-09-05', 1);

-- двойная ссылка на админа
insert into productivity_statistics(date, employee_id, admin_id) VALUES
        ('2023-10-01', 1, 1);

insert into task(start_date, end_date, complexity, productivity_statistics_id) values
        ('2023-10-01', '2023-10-31', 75, 1),
        ('2023-10-01', '2023-10-31', 50, 1),
        ('2023-10-01', '2023-10-31', 75, 1),
        ('2023-10-01', '2023-10-31', 50, 1),
        ('2023-10-01', '2023-10-31', 75, 1),
        ('2023-10-01', '2023-10-31', 50, 1),
        ('2023-10-01', '2023-10-31', 75, 1),
        ('2023-10-01', '2023-10-31', 50, 1),
        ('2023-10-01', '2023-10-31', 50, 1);

insert into equipment_possession(equipment_id, employee_id, start_date) VALUES
    (1, 2, '2023-10-31');

insert into food_compensation(payment_amount, compensation_date, is_breakfast, employee_id) VALUES
    (40000, '2023-09-20', true, 3);

insert into course_enrollment(employee_id, course_id) values
    (2, 2);



