CREATE TABLE DBO.DM_TEMPO (
SK_TEMPO          INT ,
DT_CALENDARIO     DATE,
NU_DIA            INT,
NU_DIA_SEMANA     INT,
DS_DIA_SEMANA     VARCHAR(50),
NU_MES            INT,
DS_MES            VARCHAR(50),
NU_BIMESTRE       INT,
DS_BIMESTRE       VARCHAR(50),
NU_TRIMESTRE      INT,
DS_TRIMESTRE      VARCHAR(50),
NU_SEMESTRE       INT,
DS_SEMESTRE       VARCHAR(50),
NU_ANO            INT,
FL_DIA_UTIL       CHAR(2),
FL_FERIADO        CHAR(2)
)
GO
DECLARE 
@DT_INICIAL        DATE, 
@DT_FINAL          DATE, 
@SK_TEMPO          INT,
@DT_CALENDARIO     DATE,
@NU_DIA            INT,
@NU_DIA_SEMANA     INT,
@DS_DIA_SEMANA     VARCHAR(50),
@NU_MES            INT,
@DS_MES            VARCHAR(50),
@NU_BIMESTRE       INT,
@DS_BIMESTRE       VARCHAR(50),
@NU_TRIMESTRE      INT,
@DS_TRIMESTRE      VARCHAR(50),
@NU_SEMESTRE       INT,
@DS_SEMESTRE       VARCHAR(50),
@NU_ANO            INT,
@FL_DIA_UTIL       CHAR(2),
@FL_FERIADO        CHAR(2)

set @DT_INICIAL = '01/01/1900'
set @DT_FINAL = '31/12/2012'

WHILE @DT_INICIAL <= @DT_FINAL
BEGIN
SET @DT_CALENDARIO = @DT_INICIAL
SET @SK_TEMPO =  REPLACE(@DT_CALENDARIO, '-', '')
SET @NU_DIA = DAY(@DT_CALENDARIO)
SET @NU_DIA_SEMANA = DATEPART(WEEKDAY,@DT_CALENDARIO)
SET @NU_ANO = YEAR(@DT_CALENDARIO)
SET @NU_MES = MONTH(@DT_CALENDARIO)
 


SET @DS_DIA_SEMANA = CASE 
WHEN @NU_DIA_SEMANA = 1  THEN 'DOMINGO'
WHEN @NU_DIA_SEMANA = 2  THEN 'SEGUNDA-FEIRA'
WHEN @NU_DIA_SEMANA = 3  THEN 'TERÇA-FEIRA'
WHEN @NU_DIA_SEMANA = 4  THEN 'QUARTA-FEIRA'
WHEN @NU_DIA_SEMANA = 5  THEN 'QUINTA-FEIRA' 
WHEN @NU_DIA_SEMANA = 6  THEN 'SEXTA-FEIRA'
ELSE 'SÁBADO' END


IF @NU_DIA_SEMANA IN (1,7) 
SET @FL_DIA_UTIL = 'N'
ELSE SET @FL_DIA_UTIL = 'S'

SET @DS_MES = CASE 
WHEN @NU_MES = 1  THEN 'JANEIRO'
WHEN @NU_MES = 2  THEN 'FEVEREIRO'
WHEN @NU_MES = 3  THEN 'MARÇO'
WHEN @NU_MES = 4  THEN 'ABRIL'
WHEN @NU_MES = 5  THEN 'MAIO'
WHEN @NU_MES = 6  THEN 'JUNHO' 
WHEN @NU_MES = 7  THEN 'JULHO'
WHEN @NU_MES = 8  THEN 'AGOSTO'
WHEN @NU_MES = 9  THEN 'SETEMBRO'
WHEN @NU_MES = 10 THEN 'OUTUBRO'
WHEN @NU_MES = 11 THEN 'NOVEMBRO'
WHEN @NU_MES = 12 THEN 'DEZEMBRO' END
 
SET @NU_BIMESTRE    =  CASE 
WHEN @NU_MES IN (1,2)  THEN 1
WHEN @NU_MES IN (3,4)  THEN 2
WHEN @NU_MES IN (5,6)  THEN 3
WHEN @NU_MES IN (7,8)  THEN 4
WHEN @NU_MES IN (9,10) THEN 5
WHEN @NU_MES IN (11,12)THEN 6 END

SET @DS_BIMESTRE    =   CASE 
WHEN @NU_MES IN (1,2)   THEN '1º BIMESTRE'
WHEN @NU_MES IN (3,4)   THEN '2º BIMESTRE'
WHEN @NU_MES IN (5,6)   THEN '3º BIMESTRE'
WHEN @NU_MES IN (7,8)   THEN '4º BIMESTRE'
WHEN @NU_MES IN (9,10)  THEN '5º BIMESTRE'
WHEN @NU_MES IN (11,12) THEN '6º BIMESTRE'
END

SET @NU_TRIMESTRE     = CASE
WHEN @NU_MES IN (1,2,3) THEN 1
WHEN @NU_MES IN (4,5,6) THEN 2
WHEN @NU_MES IN (7,8,9) THEN 3
ELSE 4 END 

SET @DS_TRIMESTRE        = CASE
WHEN @NU_MES IN (1,2,3)    THEN '1º TRIIMESTRE'
WHEN @NU_MES IN (4,5,6)    THEN '2º TRIIMESTRE'
WHEN @NU_MES IN (7,8,9)    THEN '3º TRIIMESTRE'
WHEN @NU_MES IN (10,11,12) THEN '4º TRIIMESTRE' END

IF (@NU_MES < 7) SET @NU_SEMESTRE = 1
ELSE SET @NU_SEMESTRE = 2

IF @NU_MES < 7
SET     @DS_SEMESTRE   = '1º SEMESTRE'
ELSE SET @DS_SEMESTRE  = '2º SEMESTRE'



IF 
(@NU_MES = 1  AND @NU_DIA =  1) OR --Confraternização universal
(@NU_MES = 4  AND @NU_DIA = 21) OR --Tiradentes
(@NU_MES = 5  AND @NU_DIA = 1) OR  --Dia do trabalho
(@NU_MES = 9  AND @NU_DIA = 7)  OR --Independência do brasil
(@NU_MES = 10 AND @NU_DIA = 12) OR --Nossa senhora aparecida
(@NU_MES = 11 AND @NU_DIA = 2)  OR --Finados
(@NU_MES = 11 AND @NU_DIA = 15) OR --Proclamação da república
(@NU_MES = 12 AND @NU_DIA = 25)    --Natal
SET @FL_FERIADO = 'S'
ELSE SET @FL_FERIADO = 'N'

INSERT INTO DBO.DM_TEMPO
SELECT 
@SK_TEMPO 
,@DT_CALENDARIO     
,@NU_DIA            
,@NU_DIA_SEMANA     
,@DS_DIA_SEMANA     
,@NU_MES           
,@DS_MES            
,@NU_BIMESTRE       
,@DS_BIMESTRE       
,@NU_TRIMESTRE    
,@DS_TRIMESTRE      
,@NU_SEMESTRE      
,@DS_SEMESTRE       
,@NU_ANO           
,@FL_DIA_UTIL       
,@FL_FERIADO        
    
SET @dt_inicial = dateadd(DAY,1,@dt_inicial) 
END;
