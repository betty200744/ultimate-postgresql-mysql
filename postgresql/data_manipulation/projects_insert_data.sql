insert into projects (project_name, git_url, version_control, num_commits, languages, last_sync_time)
VALUES ('a1', 'a1', 'github', 1, '{}', current_timestamp),
       ('b1', 'b1', 'github', 2, '{}', current_timestamp),
       ('c1', 'c1', 'github', 3, '{}', current_timestamp),
       ('d1', 'd1', 'github', 4, '{}', current_timestamp),
       ('e1', 'e1', 'github', 5, '{}', current_timestamp),
       ('f1', 'f1', 'github', 6, '{}', current_timestamp),
       ('g1', 'g1', 'github', 7, '{}', current_timestamp),
       ('h1', 'h1', 'github', 8, '{}', current_timestamp),
       ('a2', 'a2', 'gitlab', 1, '{}', current_timestamp),
       ('b2', 'b2', 'gitlab', 2, '{}', current_timestamp),
       ('c2', 'c2', 'gitlab', 3, '{}', current_timestamp),
       ('d2', 'd2', 'gitlab', 4, '{}', current_timestamp),
       ('e2', 'e2', 'gitlab', 5, '{}', current_timestamp),
       ('f2', 'f2', 'gitlab', 6, '{}', current_timestamp),
       ('g2', 'g2', 'gitlab', 7, '{}', current_timestamp);

with version_control_commits as (select version_control, sum(num_commits) as total_commits
                                 from projects
                                 group by version_control)
select *
from projects
where version_control in (select version_control from version_control_commits order by total_commits desc limit 1);