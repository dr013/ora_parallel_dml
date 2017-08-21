create or replace function prl_run_proc (
    l_cur_pak IN prl_cursor_type.cur_pak /*sys_refcursor*/
) return pak_num_arr
parallel_enable(partition l_cur_pak by range (id)) /*ANY*/
pipelined
is
    pragma autonomous_transaction;
    pk_tab  pak_num_arr;
    cnt     integer         := 0;
    l_sid   number          := 0;
    l_limit integer         := 1000;
begin
    select sys_context('USERENV', 'SID') into lsid  from dual;
    loop
        fetch pak_cur bulk collect into pk_tab limit l_limit;
        exit when pk_tab.count() = 0;

        forall i in pk_tab.first .. pk_tab.last
            update example_table
               set total_value_tmp = total_value /* 1000 /
                 , current_year_value_tmp = current_year_value /** 1000*/
                 , first_year_value_tmp = first_year_value /** 1000*/
                 , second_year_value_tmp = second_year_value /** 1000*/
                 , next_years_value_tmp = next_years_value /** 1000*/
                 , ses_id = l_sid
         where  id = pk_tab(i);

        cnt := cnt + pk_tab.COUNT;
        if MOD(cnt, 100000) = 0 then
            --dbms_output.put_line('cnt='||cnt);
            commit;
            --
            --SYS.dbms_lock.sleep (3);
            --
            --dbms_output.put_line('cnt='||cnt);

            commit;
            pipe row(cnt);
            --CLOSE pak_cur;

        end if;
    end loop;
    return;
end prl_run_proc;
/
