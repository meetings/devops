; Zone file for meetin.gs
; vim: set ts=8 nolist ft=bindzone :
;
$TTL	86400
@	IN	SOA	meetin.gs. root.meetin.gs. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;
@	IN	NS	ns1.meetin.gs.
ns1	IN	A	192.168.1.17
