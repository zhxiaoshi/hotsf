*! Version 1.0 27Mar2018 
*! Author: Xiaoshi Zhou
*! Contact E-mail: xiaoshi.zhou@outlook.com
*! Update time: 27Mar2018
*******************************************
cap program drop hotsf
program define hotsf
version 12.0

args num


tempname temfile //生成一个临时句柄`handle’

copy "https://logec.repec.org/scripts/itemstat.pf?topnum=`num'&type=redif-software&sortby=ld&.submit=New+List" `temfile'.txt,replace

qui: infix strL v 1-20000 using `temfile'.txt ,clear 
qui: keep if index(v,`"</a><br><i>"' )|  index(v,`"<td class="statnumber rightmost">"')
preserve 
qui: gen v1=""
 forvalue i=1(3)`=_N'{
	qui: replace v1 = v[`i'] in `i'
}
qui: drop if v1==""
qui: split v1,parse("<td class='rightmost'><a href='/scripts/paperstat.pf?h=repec:*" `"'>"' "</a><br><i>")
qui: keep v13
ren v13 SoftwareItem
qui: save name,replace 
restore


qui: gen v1=""
forvalue i=2(3)`=_N'{
qui:	replace v1 = v[`i'] in `i'
}
qui: drop if v1==""
qui: split v1,parse(`"<td class="statnumber rightmost">"' "</td>")
qui: keep v12
qui: ren v12 Num


qui: merge 1:1 _n using name,nogen
order SoftwareItem Num


 list 

erase `temfile'.txt
erase name.dta
clear

end
