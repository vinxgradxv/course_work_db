CREATE INDEX admin_name_idx ON admin USING hash(name);
CREATE INDEX course_name_idx ON course USING hash(name);
CREATE INDEX task_complexity_idx ON task USING btree(complexity);
CREATE INDEX productivity_statistics_date_idx ON productivity_statistics USING btree(date);
CREATE INDEX employee_name_idx ON employee USING hash(name);