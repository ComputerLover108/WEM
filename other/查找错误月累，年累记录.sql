SELECT * FROM (
	SELECT *,
	lead(month, 1, 0) over w AS last_month,
	lead(year, 1, 0) over w AS last_year
	FROM t1 window w AS(PARTITION BY to_char(v_d,'yyyy') ORDER BY v_d DESC)
) t
WHERE t.last_month + data != t.month
OR t.last_year + data != t.year;