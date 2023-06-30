-- PIVOT 절
-- Oracle 11g 버전부터 사용 가능
-- FROM 절과 WHERE 절 사이에 기술한다.
	-- aggregate_funtion(arg)에는 PIVOT 결과로 출력할 값을 지정
	-- FOR 절에는 PIVOT 기준 컬럼을 지정
	-- IN 절에는 PIVOT 기준 컬럼의 값을 지정
SELECT Col1, Col2, ...
	FROM 테이블/인라인 뷰
   PIVOT (aggregate_funtsion(arg) [, aggregate_function(arg2),...]
   		FOR Col1 [,Col2, ...]
		  IN (값1 [, 값2,...)
		 );

SELECT *
	FROM (SELECT a.DEPTNO, a.SAL FROM EMP a) a
	PIVOT (sum(a.SAL)
		FOR deptno 
	 	 IN (10,20,30)
	 );
	
-- 부분 집계를 활용한 PIVOT 기능 구현
SELECT SUM(CASE WHEN a.deptno = 10 THEN a.sal END) AS D10_SUMSAL
      ,SUM(CASE WHEN a.deptno = 20 THEN a.sal END) AS D20_SUMSAL
      ,SUM(CASE WHEN a.deptno = 30 THEN a.sal END) AS D30_SUMSAL
	FROM emp a;

-- PIVOT 절 내에서 참조하지 않은 컬럼들을 기준으로 행이 그룹화 된다.
	-- 일반적으로 인라인 뷰 or with 문으로 컬럼을 한정한다
SELECT *
	FROM emp a
	PIVOT (SUM(a.sal)
		FOR deptno
		 IN (10
		    ,20
		    ,30
		    )
		  );

		
-- IN 절에 지정한 값에 대해서만 PIVOT을 수행한다.
-- 집계 함수와 IN 절에 별칭(Alias)을 지정할 수 있다.
	-- IN 절에 지정한 별칭 ||'ㅡ'|| 집계 함수에 지정한 별칭으로 최종 결과 열의 Label이 지정된다.
SELECT job, D10_SUMSAL, D30_SUMSAL
	FROM (SELECT a.job
			    ,a.DEPTNO
			    ,a.SAL
		    FROM EMP a
		 ) a
	PIVOT (sum(a.SAL) AS SUMSAL
		FOR deptno 
	 	 IN (10 AS D10
	 	    ,30 AS D30
	 	    )
	      );			
	
-- 집계 함수와 IN 절 둘 중 하나에만 별칭을 지정하는 것도 가능하다.
	-- 집계함수와 IN절 모두에 별칭을 지정하는 것이 좋다.	

-- 여러 개의 집계 함수를 사용하여 PIVOT을 수행할 수 있다.
	-- PIVOT에 의해 집계 함수의 개수*IN 절 값의 개수 만큼 결과 열이 출력된다
SELECT *
	FROM (SELECT a.job
			    ,a.DEPTNO
			    ,a.SAL 
		   FROM EMP a
		 ) a
	PIVOT (sum(a.SAL) AS SUMSAL
		  ,count(*) AS CNT
		FOR deptno 
	 	 IN (10 AS D10
	 	    ,20 AS D20
	 	    ,30 AS D30
	 	    )
	      );			
	
--집계함수를 2개 이상 사용하였을 때,별칭을 지정하지 않으면 문법 오류가 발생한다.
	--PIVOT 절 사용시 집계 함수와 IN 절 모두에 별칭을 지정하는 것이 좋다.
	--올바른 사용 예시
SELECT *
	FROM (SELECT a.job
	            ,a.deptno
	            ,a.sal 
	       FROM emp a
	     ) a
	PIVOT ( SUM(a.sal) AS SUMSAL
	       ,COUNT(*) AS CNT
	     FOR deptno
	      IN (20 AS D20
	         ,30 AS D30
	         )
	      );
	     
	 --오류 발생 예시
SELECT *
	FROM (SELECT a.job
	            ,a.deptno
	            ,a.sal 
	       FROM emp a
	     ) a
	PIVOT (SUM(a.sal)
	      ,COUNT(*)
	     FOR deptno
	      IN (20 AS D20
	         ,30 AS D30)
	      );      
