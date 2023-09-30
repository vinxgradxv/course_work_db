create table admin(
    id serial primary key,
    name varchar not null,
    age int not null,
    division varchar
);

create table employee(
    id serial primary key,
    name varchar not null,
    age int not null,
    division varchar,
    admin_id int references admin
);

create table enterprise_equipment(
    id serial primary key,
    type varchar,
    serial_number int not null check ( serial_number > 0 ),
    description varchar
);

create table work_time(
    id serial primary key,
    start_timestamp timestamp not null,
    end_timestamp timestamp,
    employee_id int references employee
);

create table food_compensation(
    id serial primary key,
    payment_amount int not null check ( payment_amount >= 0 ),
    compensation_date date not null,
    is_breakfast boolean,
    employee_id int references employee
);

create table course(
    id serial primary key,
    name varchar not null,
    description varchar,
    category varchar
);

create table dayoff_request(
    id serial primary key,
    start_date date,
    end_date date,
    is_approved boolean default false,
    employee_id int references employee
);

create table productivity_statistics(
    id serial primary key,
    date date not null,
    manager_review varchar,
    employee_id int not null references employee,
    admin_id int not null references admin
);

create table task(
    id serial primary key,
    start_date date,
    end_date date,
    complexity int not null check ( complexity >= 0 ),
    status varchar default 'New',
    productivity_statistics_id int references productivity_statistics
);


create table equipment_possession(
    id serial primary key,
    equipment_id int not null references enterprise_equipment,
    employee_id int not null references employee,
    start_date date not null,
    end_date date
);

create table course_enrollment(
    employee_id int not null references employee,
    course_id int not null references course,
    is_finished boolean default false
);