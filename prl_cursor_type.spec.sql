create or replace package prl_cursor_type
is
    cursor l_cur_id is select object_id as id from all_objects where rownum < 2;
    type l_cur_pak is ref cursor return l_cur_id%rowtype;
end prl_cursor_type;
/
