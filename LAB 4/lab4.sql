select course_id, title from course where credits > 3;
select room_number from classroom where building = 'Watson' or building = 'Packard';
select course_id, title from course where dept_name = 'Comp. Sci.';
select course.course_id, course.title from course, section
    where course.course_id = section.course_id and section.semester = 'Fall';
select id, name from student where tot_cred > 45 and tot_cred < 90;
select id, name from student where name like '%a' or name like '%e' or
    name like '%i' or name like '%o' or name like '%u' or name like '%y';
select course.course_id, course.title from course, prereq
    where course.course_id = prereq.course_id and prereq.prereq_id = 'CS-101';

select dept_name, avg(salary) from instructor group by dept_name order by avg(salary);
select building, count(distinct course_id) from section
    group by building order by count(distinct course_id) desc limit 1;
select dept_name, count(course_id) from course group by dept_name having count(course_id)=
    (select count(course_id) from course
        group by dept_name order by count(course_id) limit 1);
select student.id, student.name, count(takes.course_id) from student, takes
    where student.id = takes.id and takes.course_id in
        (select course_id from course where dept_name = 'Comp. Sci.')
            group by student.id having count(takes.course_id) > 3;
select id, name from instructor where dept_name in ('Biology', 'Philosophy', 'Music');
select instructor.id, instructor.name from instructor, teaches
    where instructor.id = teaches.id and teaches.year = 2018 except
        select instructor.id, instructor.name from instructor, teaches
            where instructor.id = teaches.id and teaches.year = 2017;

select distinct student.id, student.name from student, takes where student.id = takes.id and
    takes.course_id in (select course_id from course where dept_name = 'Comp. Sci.') and
        takes.grade in ('A', 'A-') order by student.name;
select distinct instructor.id, instructor.name from instructor, advisor, takes where
    instructor.id = advisor.i_id and advisor.s_id = takes.id and takes.grade in ('F', 'D', 'C-', 'C', 'C+', 'B-');
select student.dept_name from student except select student.dept_name from student, takes
    where student.id = takes.id and takes.grade in ('F', 'C');
select id, name from instructor except select instructor.id, instructor.name from instructor, teaches, takes
    where instructor.id = teaches.id and teaches.course_id = takes.course_id and teaches.sec_id = takes.sec_id
        and teaches.semester = takes.semester and teaches.year = takes.year and takes.grade = 'A';
select distinct course.course_id, course.title from course, section, time_slot
    where course.course_id = section.course_id and section.time_slot_id = time_slot.time_slot_id
      and time_slot.end_hr < 13;