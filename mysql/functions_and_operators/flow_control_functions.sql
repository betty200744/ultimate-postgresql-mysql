# flow control functions

select case 1 when 1 then 'one' when 2 then 'two' else 'more' end;
select case  when 1 > 0 then 'true' else 'false' end;

select bin('8');
select concat('a', 'b');
select concat_ws(',', 'a', 'b');
select insert('a', 2, 3, 'bcd')