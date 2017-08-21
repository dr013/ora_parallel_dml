create or replace package prl_cursor_type
is
    cursor l_cur_id is select object_id as id from all_objects where rownum<2;
    TYPE l_cur_pak is ref cursor return l_id_cur%rowtype;
end prl_cursor_type;
/
