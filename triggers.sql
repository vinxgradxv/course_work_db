CREATE OR REPLACE FUNCTION check_dates()
    RETURNS TRIGGER AS
$$
DECLARE
BEGIN
    IF NEW.end_date < NEW.start_date
    THEN
        RAISE EXCEPTION 'start_date should be not greater than end_date';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_task_dates_trigger
    AFTER INSERT OR UPDATE
    ON task
    FOR EACH ROW
EXECUTE PROCEDURE check_dates();

CREATE TRIGGER check_equipment_pos_dates_trigger
    AFTER INSERT OR UPDATE
    ON equipment_possession
    FOR EACH ROW
EXECUTE PROCEDURE check_dates();

CREATE TRIGGER check_dayoff_dates_trigger
    AFTER INSERT OR UPDATE
    ON dayoff_request
    FOR EACH ROW
EXECUTE PROCEDURE check_dates();

CREATE OR REPLACE FUNCTION check_timestamp()
    RETURNS TRIGGER AS
$$
DECLARE
BEGIN
    IF NEW.start_timestamp > NEW.end_timestamp
    THEN
        RAISE EXCEPTION 'start_timestamp should be not greater than end_timestamp';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_worktime_timestamps_trigger
    AFTER INSERT OR UPDATE
    ON work_time
    FOR EACH ROW
EXECUTE PROCEDURE check_timestamp();


CREATE OR REPLACE FUNCTION check_tasks_count()
    RETURNS TRIGGER AS
$$
DECLARE
    MAX_COUNT int := 10;
    CURRENT_COUNT int;
BEGIN
    SELECT INTO CURRENT_COUNT count(id) from task t where t.productivity_statistics_id=NEW.productivity_statistics_id;
    IF CURRENT_COUNT > MAX_COUNT
    THEN
        RAISE EXCEPTION 'Too many tasks for this employee in one sprint';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_task_count_trigger
    AFTER INSERT OR UPDATE
    ON task
    FOR EACH ROW
EXECUTE PROCEDURE check_tasks_count();


CREATE OR REPLACE FUNCTION check_employees_count()
    RETURNS TRIGGER AS
$$
DECLARE
    MAX_COUNT int := 5;
    CURRENT_COUNT int;
BEGIN
    SELECT INTO CURRENT_COUNT count(id) from employee e where e.admin_id=NEW.admin_id;
    IF CURRENT_COUNT > MAX_COUNT
    THEN
        RAISE EXCEPTION 'Too many employees for this admin';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_employees_count_trigger
    AFTER INSERT OR UPDATE
    ON employee
    FOR EACH ROW
EXECUTE PROCEDURE check_employees_count();

--внутрь ифа заходит, но значение не меняет, я не понимаю(
CREATE OR REPLACE FUNCTION check_compensation_amount()
    RETURNS TRIGGER AS
$func$
DECLARE
    MAX_AMOUNT int := 50000;
    CURRENT_AMOUNT int;
BEGIN
    SELECT INTO CURRENT_AMOUNT sum(fc.payment_amount) from food_compensation fc
                                                        where fc.employee_id = NEW.employee_id
                                                        and fc.compensation_date=NEW.compensation_date;
    IF CURRENT_AMOUNT > MAX_AMOUNT
    THEN
        ---RAISE EXCEPTION 'Too many employees for this admin';
        NEW.payment_amount := NEW.payment_amount - (CURRENT_AMOUNT - MAX_AMOUNT);
    END IF;
    RETURN NEW;
END
$func$ LANGUAGE plpgsql;

CREATE TRIGGER check_compensation_amount_trigger
    AFTER INSERT OR UPDATE
    ON food_compensation
    FOR EACH ROW
EXECUTE PROCEDURE check_compensation_amount();

CREATE OR REPLACE FUNCTION check_dayoff_count()
    RETURNS TRIGGER AS
$$
DECLARE
    MAX_COUNT int := 3;
    CURRENT_COUNT int;
BEGIN
    SELECT INTO CURRENT_COUNT count(id) from dayoff_request dr where dr.employee_id=NEW.employee_id
                                                                and dr.end_date < CURRENT_COUNT
                                                                and dr.is_approved=false;
    IF CURRENT_COUNT > MAX_COUNT
    THEN
        RAISE EXCEPTION 'Too mane dayoff requests for this employee';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_dayoff_count_trigger
    AFTER INSERT OR UPDATE
    ON dayoff_request
    FOR EACH ROW
EXECUTE PROCEDURE check_dayoff_count();



