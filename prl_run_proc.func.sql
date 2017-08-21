create or replace function prl_run_proc (
    l_cur_pak in prl_cursor_type.cur_pak /*sys_refcursor*/
) return prl_num_arr
parallel_enable(partition l_cur_pak by range (id)) /*ANY*/
pipelined
is
    pragma autonomous_transaction;
    l_pk_tab  pak_num_arr;
    cnt     integer         := 0;
    l_sid   number          := 0;
    l_limit integer         := 1000;
begin
    select sys_context('USERENV', 'SID') into lsid  from dual;
    loop
        fetch pak_cur bulk collect into l_pk_tab limit l_limit;
        exit when l_pk_tab.count() = 0;

        forall i in l_pk_tab.first .. l_pk_tab.last
            update example_table
               set my_col = new_value
                 , ses_id = l_sid
         where  id = l_pk_tab(i);

        cnt := cnt + l_pk_tab.COUNT;
        if mod(cnt, 100000) = 0 then
            --dbms_output.put_line('cnt='||cnt);
            commit;
            --dbms_output.put_line('cnt='||cnt);
            pipe row(cnt);
        end if;
    end loop;
	commit;
    return;
end prl_run_proc;
/
