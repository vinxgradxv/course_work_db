CREATE OR REPLACE FUNCTION get_compensation_sum(comp_start_date date, comp_end_date date, emp_id int)
  RETURNS int
  LANGUAGE plpgsql
AS $$
DECLARE
    RESULT int;
BEGIN
    select into RESULT sum(fc.payment_amount) from food_compensation fc
        where (select count(*) from dayoff_request df
                        where df.start_date <= fc.compensation_date and df.end_date >= fc.compensation_date and df.is_approved=true) = 0
          and comp_start_date <= fc.compensation_date and comp_end_date >= fc.compensation_date and fc.employee_id=emp_id;

    return RESULT;
END;
$$;


CREATE OR REPLACE PROCEDURE give_equipment_to_team(emp_div varchar, equip_id int, pos_start date, pos_end date)
  LANGUAGE plpgsql
AS $$
BEGIN
    WITH equip_emp AS (
   SELECT equip_id as eq_id, emp.id as em_id, COALESCE(pos_start, CURRENT_DATE) as p_start, pos_end as p_end
   FROM employee emp
   WHERE emp.division = emp_div
)
INSERT INTO equipment_possession (equipment_id, employee_id, start_date, end_date)
SELECT eq_id, em_id, p_start, p_end
FROM equip_emp;
END;
$$;


CREATE OR REPLACE PROCEDURE assign_course_to_team(emp_div varchar, course_id int)
  LANGUAGE plpgsql
AS $$
BEGIN
    WITH course_emp AS (
   SELECT course_id as c_id, emp.id as em_id
   FROM employee emp
   WHERE emp.division = emp_div
)
INSERT INTO course_enrollment (employee_id, course_id)
SELECT em_id, c_id
FROM course_emp;
END;
$$;


CREATE OR REPLACE PROCEDURE cancel_food_compensation_for_deadline_miss(emp_id int)
  LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE food_compensation fc set payment_amount=0
    where fc.employee_id=emp_id
        and (select min(task.end_date) from task where task.productivity_statistics_id = (select max(id) from productivity_statistics ps where ps.employee_id=emp_id)
        and task.end_date < CURRENT_DATE and task.status != 'Done') < fc.compensation_date;
END;
$$;


CREATE OR REPLACE PROCEDURE hire_employee(emp_name varchar, emp_division varchar, emp_age int, emp_adm_id int)
  LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employee (name, age, division, admin_id) values (emp_name, emp_age, COALESCE(emp_division, 'Standard'), COALESCE(emp_adm_id, (select max(id) from admin)));
END
$$;

CREATE OR REPLACE PROCEDURE fire_employee(emp_id int)
  LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM equipment_possession ep where ep.employee_id=emp_id;
    DELETE FROM work_time wt where wt.employee_id=emp_id;
    DELETE FROM dayoff_request dr where dr.employee_id = emp_id;
    DELETE FROM course_enrollment ce where ce.employee_id = emp_id;
    DELETE FROM task t where t.productivity_statistics_id = (select ps.id from productivity_statistics ps where ps.employee_id=emp_id);
    DELETE FROM productivity_statistics ps where ps.employee_id = emp_id;
END;
$$;