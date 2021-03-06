PGDMP         !                z            superprogetto    14.1    14.1 J    `           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            a           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            b           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            c           1262    26735    superprogetto    DATABASE     r   CREATE DATABASE superprogetto WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United Kingdom.1252';
    DROP DATABASE superprogetto;
                postgres    false            k           1247    34604    enum_tematica    DOMAIN       CREATE DOMAIN public.enum_tematica AS character varying(20)
	CONSTRAINT enum_tematica_check CHECK (((VALUE)::text = ANY ((ARRAY['Inglese'::character varying, 'Algebra'::character varying, 'Informatica'::character varying, 'Matematica'::character varying])::text[])));
 "   DROP DOMAIN public.enum_tematica;
       public          postgres    false            ?            1255    26736    conferma_prenotazione()    FUNCTION     b  CREATE FUNCTION public.conferma_prenotazione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
--Prenotazioni si fanno entro un'ora prima della lezione e dieci minuti dopo la sua fine;--
IF((Current_Date+Current_Time<old.data_prenotazione+old.data_prenotazione-INTERVAL '1 ora')
OR (Current_Date+Current_Time>old.data_prenotazione+old.data_prenotazione+INTERVAL '10 minuti'))
AND new.check_status='Conferma prenotazione'
THEN
RAISE EXCEPTION 'Prenotazione non disponibile al momento';
ELSEIF new.check_status='Eliminata' AND Current_Date+Current_Time>old.data_prenotazione+old.ora
THEN
RAISE EXCEPTION 'Non puoi cancellare la prenotazione al momento';
ELSEIF new.check_status='Abbandonata' AND Current_Date+Current_Time<old.data_prenotazione+old.ora+INTERVAL '10 minuti'
THEN
RAISE EXCEPTION 'Non puoi abbandonare la prenotazione';
END IF;
RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.conferma_prenotazione();
       public          postgres    false            ?            1255    26737 %   controllo_aula_non_occupata_lezione()    FUNCTION       CREATE FUNCTION public.controllo_aula_non_occupata_lezione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
contatore integer;

BEGIN    
	
	SELECT COUNT(*) INTO contatore
	FROM Public.lezione as l
	WHERE NEW.data_inizio = l.data_inizio AND NEW.id_aula = l.id_aula AND((NEW.ora_inizio< l.ora_fine AND NEW.ora_inizio > l.ora_inizio) 
																	  OR  (NEW.ora_fine>l.ora_inizio AND NEW.ora_fine<l.ora_fine));
	
	IF (contatore>0)
	THEN RAISE EXCEPTION 'AULA GIA OCCUPATA';
	END IF;
	
RETURN NEW;   
END;     
$$;
 <   DROP FUNCTION public.controllo_aula_non_occupata_lezione();
       public          postgres    false            ?            1255    34606 "   controllo_aula_non_occupata_test()    FUNCTION     ?  CREATE FUNCTION public.controllo_aula_non_occupata_test() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
contatore integer;

BEGIN    
	
	SELECT COUNT(*) INTO contatore
	FROM Public.Test as l
	WHERE NEW.data_test = l.data_test AND NEW.id_aula_test = l.id_aula_test AND((NEW.ora_inizio< l.durata AND NEW.ora_inizio > l.durata) 
																	  OR  (NEW.durata>l.ora_inizio AND NEW.durata<l.ora_fine));
	
	IF (contatore>0)
	THEN RAISE EXCEPTION 'AULA GIA OCCUPATA';
	END IF;
	
RETURN NEW;   
END;$$;
 9   DROP FUNCTION public.controllo_aula_non_occupata_test();
       public          postgres    false            ?            1255    26738    controllo_tasso_frequenza()    FUNCTION     ?   CREATE FUNCTION public.controllo_tasso_frequenza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

IF( NEW.tasso_frequenza<75.0 ) THEN

RAISE NOTICE 'VALORE SUFFICIENTE';

ELSE 
RAISE NOTICE 'VALORE INSUFFICIENTE';

END IF;

RETURN NULL;

END;
$$;
 2   DROP FUNCTION public.controllo_tasso_frequenza();
       public          postgres    false            ?            1255    26739 #   inserimento_mutltitabella_lezione()    FUNCTION        CREATE FUNCTION public.inserimento_mutltitabella_lezione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   

 BEGIN    

INSERT INTO Public."Registro_prenotazione_aula" 
	VALUES( NEW.data_inizio, NEW.ora_inizio,NEW.id_aula);

RETURN NEW;   
END;     $$;
 :   DROP FUNCTION public.inserimento_mutltitabella_lezione();
       public          postgres    false            ?            1255    26740     inserimento_mutltitabella_test()    FUNCTION     *  CREATE FUNCTION public.inserimento_mutltitabella_test() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   
   
 BEGIN    

INSERT INTO Public.registro_prenotazione_aula (data_prenotazione,ora,id_aula_reference)
	VALUES( NEW.data_test, NEW.ora_inizio, NEW.id_aula_test);

RETURN NEW;   
END;   
$$;
 7   DROP FUNCTION public.inserimento_mutltitabella_test();
       public          postgres    false            ?            1255    26741    inserisci_prenotazione()    FUNCTION     ?  CREATE FUNCTION public.inserisci_prenotazione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE Uguale INTEGER;
BEGIN
select count(*) INTO Uguale FROM registro_prenotazione_aula
WHERE new.data_prenotazione=data_prenotazione AND new.ora=ora AND new.id_aula_reference=id_aula_reference;
IF Uguale<>0
THEN
RAISE EXCEPTION 'Aula non disponibile al momento.Riprovare più tardi';
END IF;
RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.inserisci_prenotazione();
       public          postgres    false            ?            1255    26878    percentuale_frequenza()    FUNCTION     U  CREATE FUNCTION public.percentuale_frequenza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    var1 double precision;

BEGIN

var1 = NEW."presenze"*100;

var1 = var1/NEW."iscritti";

IF NEW.tasso_frequenza IS NULL
THEN
UPDATE Public.corso
SET tasso_frequenza = var1 
WHERE tasso_frequenza IS NULL;
END IF;

RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.percentuale_frequenza();
       public          postgres    false            ?            1255    26742    percentuale_riempimento()    FUNCTION     p  CREATE FUNCTION public.percentuale_riempimento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    var1 double precision;
	
BEGIN

var1 = NEW."num_presenti"*100;

var1 = var1/NEW."num_max_posti";

IF NEW.percentuale_occupata IS NULL
THEN
UPDATE Public.aula 
SET percentuale_occupata = var1 
WHERE percentuale_occupata IS NULL;
END IF;

RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.percentuale_riempimento();
       public          postgres    false            ?            1255    26874    tasso_frequenza_calcolo()    FUNCTION     L  CREATE FUNCTION public.tasso_frequenza_calcolo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    var1 double precision;

BEGIN

var1 = NEW."num_iscritti";

var1 = var1/2;

IF NEW.tasso_frequenza IS NULL
THEN
UPDATE Public.lezione
SET tasso_frequenza = var1 
WHERE tasso_frequenza IS NULL;
END IF;

RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.tasso_frequenza_calcolo();
       public          postgres    false            ?            1259    26749 	   Operatore    TABLE     S   CREATE TABLE public."Operatore" (
    "ID_Operatore" character varying NOT NULL
);
    DROP TABLE public."Operatore";
       public         heap    postgres    false            ?            1259    26754    Tematica    TABLE     ?   CREATE TABLE public."Tematica" (
    area_tematica character varying NOT NULL,
    id_corso integer NOT NULL,
    keywords character varying
);
    DROP TABLE public."Tematica";
       public         heap    postgres    false            d           0    0    TABLE "Tematica"    ACL     0   GRANT ALL ON TABLE public."Tematica" TO PUBLIC;
          public          postgres    false    211            ?            1259    26759    Test    TABLE     ?  CREATE TABLE public."Test" (
    id_test integer NOT NULL,
    "ID_Operatore" character varying NOT NULL,
    "Titolo" character varying[] NOT NULL,
    "Descrizione" character varying[],
    "Durata" time without time zone[] NOT NULL,
    ora_inizio time with time zone NOT NULL,
    "Minimo_punteggio" integer[] NOT NULL,
    "Minimo_presenze" integer[] NOT NULL,
    data_test date[],
    id_aula_test character varying
);
    DROP TABLE public."Test";
       public         heap    postgres    false            ?            1259    26764    aula    TABLE     ?   CREATE TABLE public.aula (
    num_max_posti integer NOT NULL,
    num_presenti integer,
    percentuale_occupata double precision,
    id_aula character varying NOT NULL,
    CONSTRAINT posti_max_check CHECK ((num_max_posti >= num_presenti))
);
    DROP TABLE public.aula;
       public         heap    postgres    false            ?            1259    26743    corso    TABLE     F  CREATE TABLE public.corso (
    tasso_frequenza double precision,
    area_tematica character varying(100) DEFAULT ' '::character varying NOT NULL,
    id_corso integer NOT NULL,
    nome character varying(50) NOT NULL,
    descrizione character varying(500),
    presenze double precision,
    iscritti integer NOT NULL,
    "ID_operatore" character varying,
    numero_lezioni integer,
    "ID_studente" integer,
    minimo_delle_presenze double precision GENERATED ALWAYS AS ((iscritti / 2)) STORED,
    max_presenze integer GENERATED ALWAYS AS (((iscritti * 2) + 10)) STORED
);
    DROP TABLE public.corso;
       public         heap    postgres    false            ?            1259    26770    lezione    TABLE     ]  CREATE TABLE public.lezione (
    id_lezione integer NOT NULL,
    id_corso integer,
    data_inizio date[] NOT NULL,
    ora_inizio time without time zone NOT NULL,
    num_iscritti integer,
    tasso_frequenza double precision,
    id_operatore character varying,
    numero_lezioni integer,
    id_aula character varying,
    titolo character varying,
    descrizione character varying,
    ora_fine time without time zone,
    durata integer,
    CONSTRAINT "Lezione_Tasso_Frequenza_check" CHECK (((tasso_frequenza >= (0.00)::double precision) AND (tasso_frequenza <= (100.00)::double precision)))
);
    DROP TABLE public.lezione;
       public         heap    postgres    false            ?            1259    26776    registro_prenotazione_aula    TABLE     ?   CREATE TABLE public.registro_prenotazione_aula (
    data_prenotazione date[] NOT NULL,
    ora time with time zone NOT NULL,
    id_aula_reference character varying,
    check_status character varying[]
);
 .   DROP TABLE public.registro_prenotazione_aula;
       public         heap    postgres    false            e           0    0     TABLE registro_prenotazione_aula    ACL     E   REVOKE ALL ON TABLE public.registro_prenotazione_aula FROM postgres;
          public          postgres    false    215            ?            1259    26781    studente    TABLE     ?  CREATE TABLE public.studente (
    id_studente integer NOT NULL,
    nome character varying NOT NULL,
    cognome character varying NOT NULL,
    tasso_frequenza double precision NOT NULL,
    id_operatore character varying,
    id_corso integer NOT NULL,
    punteggio_test smallint,
    CONSTRAINT "Studente_Tasso_frequenza_check" CHECK (((tasso_frequenza >= (0.00)::double precision) AND (tasso_frequenza <= (100.00)::double precision)))
);
    DROP TABLE public.studente;
       public         heap    postgres    false            f           0    0    COLUMN studente.id_corso    COMMENT     K   COMMENT ON COLUMN public.studente.id_corso IS 'Corso a cui sono iscritti';
          public          postgres    false    216            ?            1259    26787    view_controlla_frequenza    VIEW     ?  CREATE VIEW public.view_controlla_frequenza AS
 SELECT lezione.id_lezione AS "ID_Lezione",
    lezione.id_corso AS "ID_Corso",
    lezione.titolo AS "Titolo",
    lezione.data_inizio AS "Data_inizio",
    lezione.ora_inizio AS "Ora_inizio",
    lezione.tasso_frequenza,
    lezione.id_operatore AS "ID_Operatore"
   FROM public.lezione
  WHERE (lezione.tasso_frequenza >= (75)::double precision);
 +   DROP VIEW public.view_controlla_frequenza;
       public          postgres    false    214    214    214    214    214    214    214            ?            1259    26791    view_controlla_voti_frequenza    VIEW     Y  CREATE VIEW public.view_controlla_voti_frequenza AS
 SELECT studente.id_studente AS "ID_Studente",
    studente.nome AS "Nome",
    studente.cognome AS "Cognome",
    studente.tasso_frequenza,
    studente.punteggio_test
   FROM public.studente
  WHERE ((studente.punteggio_test >= 50) AND (studente.tasso_frequenza >= (75)::double precision));
 0   DROP VIEW public.view_controlla_voti_frequenza;
       public          postgres    false    216    216    216    216    216            ?            1259    26795    view_visualizza_studenti    VIEW     ?   CREATE VIEW public.view_visualizza_studenti AS
 SELECT studente.id_studente,
    studente.tasso_frequenza,
    studente.id_corso,
    studente.cognome
   FROM public.studente;
 +   DROP VIEW public.view_visualizza_studenti;
       public          postgres    false    216    216    216    216            W          0    26749 	   Operatore 
   TABLE DATA           5   COPY public."Operatore" ("ID_Operatore") FROM stdin;
    public          postgres    false    210   Nn       X          0    26754    Tematica 
   TABLE DATA           G   COPY public."Tematica" (area_tematica, id_corso, keywords) FROM stdin;
    public          postgres    false    211   ?n       Y          0    26759    Test 
   TABLE DATA           ?   COPY public."Test" (id_test, "ID_Operatore", "Titolo", "Descrizione", "Durata", ora_inizio, "Minimo_punteggio", "Minimo_presenze", data_test, id_aula_test) FROM stdin;
    public          postgres    false    212   ?o       Z          0    26764    aula 
   TABLE DATA           Z   COPY public.aula (num_max_posti, num_presenti, percentuale_occupata, id_aula) FROM stdin;
    public          postgres    false    213   Yq       V          0    26743    corso 
   TABLE DATA           ?   COPY public.corso (tasso_frequenza, area_tematica, id_corso, nome, descrizione, presenze, iscritti, "ID_operatore", numero_lezioni, "ID_studente") FROM stdin;
    public          postgres    false    209   ?q       [          0    26770    lezione 
   TABLE DATA           ?   COPY public.lezione (id_lezione, id_corso, data_inizio, ora_inizio, num_iscritti, tasso_frequenza, id_operatore, numero_lezioni, id_aula, titolo, descrizione, ora_fine, durata) FROM stdin;
    public          postgres    false    214   ?t       \          0    26776    registro_prenotazione_aula 
   TABLE DATA           m   COPY public.registro_prenotazione_aula (data_prenotazione, ora, id_aula_reference, check_status) FROM stdin;
    public          postgres    false    215   ?v       ]          0    26781    studente 
   TABLE DATA           w   COPY public.studente (id_studente, nome, cognome, tasso_frequenza, id_operatore, id_corso, punteggio_test) FROM stdin;
    public          postgres    false    216   ww       ?           2606    26800 ,   registro_prenotazione_aula Aula_non_occupata 
   CONSTRAINT     ?   ALTER TABLE ONLY public.registro_prenotazione_aula
    ADD CONSTRAINT "Aula_non_occupata" UNIQUE (data_prenotazione, ora, id_aula_reference) INCLUDE (data_prenotazione, ora, id_aula_reference);
 X   ALTER TABLE ONLY public.registro_prenotazione_aula DROP CONSTRAINT "Aula_non_occupata";
       public            postgres    false    215    215    215            ?           2606    26802    corso Corso_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.corso
    ADD CONSTRAINT "Corso_pkey" PRIMARY KEY (id_corso);
 <   ALTER TABLE ONLY public.corso DROP CONSTRAINT "Corso_pkey";
       public            postgres    false    209            ?           2606    26804 .   lezione Data_od_ora_in_cui_aula_già_prenotata 
   CONSTRAINT     ?   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "Data_od_ora_in_cui_aula_già_prenotata" UNIQUE (id_aula, data_inizio, ora_inizio);
 Z   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "Data_od_ora_in_cui_aula_già_prenotata";
       public            postgres    false    214    214    214            ?           2606    26806 
   lezione PK 
   CONSTRAINT     g   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "PK" PRIMARY KEY (id_lezione) INCLUDE (id_lezione);
 6   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "PK";
       public            postgres    false    214            ?           2606    26808    aula PK_Aula 
   CONSTRAINT     c   ALTER TABLE ONLY public.aula
    ADD CONSTRAINT "PK_Aula" PRIMARY KEY (id_aula) INCLUDE (id_aula);
 8   ALTER TABLE ONLY public.aula DROP CONSTRAINT "PK_Aula";
       public            postgres    false    213            ?           2606    26810    Operatore PK_Operatore 
   CONSTRAINT     }   ALTER TABLE ONLY public."Operatore"
    ADD CONSTRAINT "PK_Operatore" PRIMARY KEY ("ID_Operatore") INCLUDE ("ID_Operatore");
 D   ALTER TABLE ONLY public."Operatore" DROP CONSTRAINT "PK_Operatore";
       public            postgres    false    210            ?           2606    26812    studente Studente_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT "Studente_pkey" PRIMARY KEY (id_studente);
 B   ALTER TABLE ONLY public.studente DROP CONSTRAINT "Studente_pkey";
       public            postgres    false    216            ?           2606    26814    Tematica Tematica_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public."Tematica"
    ADD CONSTRAINT "Tematica_pk" PRIMARY KEY (area_tematica) INCLUDE (area_tematica);
 B   ALTER TABLE ONLY public."Tematica" DROP CONSTRAINT "Tematica_pk";
       public            postgres    false    211            ?           2606    26816    Test Test_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "Test_pkey" PRIMARY KEY (id_test);
 <   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "Test_pkey";
       public            postgres    false    212            ?           2606    26818    corso Unique_Corso 
   CONSTRAINT     X   ALTER TABLE ONLY public.corso
    ADD CONSTRAINT "Unique_Corso" UNIQUE (area_tematica);
 >   ALTER TABLE ONLY public.corso DROP CONSTRAINT "Unique_Corso";
       public            postgres    false    209            ?           2606    26820    Test unicita_test 
   CONSTRAINT     v   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT unicita_test UNIQUE (id_aula_test, data_test, id_test, ora_inizio);
 =   ALTER TABLE ONLY public."Test" DROP CONSTRAINT unicita_test;
       public            postgres    false    212    212    212    212            ?           2606    26822    studente uno_studente_un_corso 
   CONSTRAINT     j   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT uno_studente_un_corso UNIQUE (id_studente, id_corso);
 H   ALTER TABLE ONLY public.studente DROP CONSTRAINT uno_studente_un_corso;
       public            postgres    false    216    216            ?           1259    26823    fki_FK    INDEX     @   CREATE INDEX "fki_FK" ON public.lezione USING btree (id_corso);
    DROP INDEX public."fki_FK";
       public            postgres    false    214            ?           1259    26824    fki_FK_Aula    INDEX     D   CREATE INDEX "fki_FK_Aula" ON public.lezione USING btree (id_aula);
 !   DROP INDEX public."fki_FK_Aula";
       public            postgres    false    214            ?           1259    26825    fki_FK_Corso    INDEX     J   CREATE INDEX "fki_FK_Corso" ON public.corso USING btree ("ID_operatore");
 "   DROP INDEX public."fki_FK_Corso";
       public            postgres    false    209            ?           1259    26826    fki_FK_Studente    INDEX     N   CREATE INDEX "fki_FK_Studente" ON public.studente USING btree (id_operatore);
 %   DROP INDEX public."fki_FK_Studente";
       public            postgres    false    216            ?           1259    26827    fki_FK_Tematica    INDEX     L   CREATE INDEX "fki_FK_Tematica" ON public."Tematica" USING btree (id_corso);
 %   DROP INDEX public."fki_FK_Tematica";
       public            postgres    false    211            ?           1259    26828    fki_FK_Test    INDEX     J   CREATE INDEX "fki_FK_Test" ON public."Test" USING btree ("ID_Operatore");
 !   DROP INDEX public."fki_FK_Test";
       public            postgres    false    212            ?           1259    26829    fki_FK_prenotazione    INDEX     i   CREATE INDEX "fki_FK_prenotazione" ON public.registro_prenotazione_aula USING btree (id_aula_reference);
 )   DROP INDEX public."fki_FK_prenotazione";
       public            postgres    false    215            ?           1259    26830    fki_ID_Operatore    INDEX     T   CREATE INDEX "fki_ID_Operatore" ON public."Operatore" USING btree ("ID_Operatore");
 &   DROP INDEX public."fki_ID_Operatore";
       public            postgres    false    210            ?           1259    26831    fki_fk_aula    INDEX     F   CREATE INDEX fki_fk_aula ON public."Test" USING btree (id_aula_test);
    DROP INDEX public.fki_fk_aula;
       public            postgres    false    212            ?           1259    26832    fki_fk_votii    INDEX     K   CREATE INDEX fki_fk_votii ON public.studente USING btree (punteggio_test);
     DROP INDEX public.fki_fk_votii;
       public            postgres    false    216            ?           2620    26875    lezione calcolo_tasso    TRIGGER     ?   CREATE TRIGGER calcolo_tasso AFTER INSERT OR UPDATE ON public.lezione FOR EACH ROW EXECUTE FUNCTION public.tasso_frequenza_calcolo();
 .   DROP TRIGGER calcolo_tasso ON public.lezione;
       public          postgres    false    214    221            ?           2620    26833 0   registro_prenotazione_aula conferma_prenotazione    TRIGGER     ?   CREATE TRIGGER conferma_prenotazione BEFORE UPDATE ON public.registro_prenotazione_aula FOR EACH ROW EXECUTE FUNCTION public.conferma_prenotazione();
 I   DROP TRIGGER conferma_prenotazione ON public.registro_prenotazione_aula;
       public          postgres    false    215    226            ?           2620    26834 !   lezione controllo_tasso_frequenza    TRIGGER     ?   CREATE TRIGGER controllo_tasso_frequenza AFTER INSERT OR UPDATE OF tasso_frequenza ON public.lezione FOR EACH STATEMENT EXECUTE FUNCTION public.controllo_tasso_frequenza();
 :   DROP TRIGGER controllo_tasso_frequenza ON public.lezione;
       public          postgres    false    214    214    234            ?           2620    26835    Test inserimento_tra_tabelle    TRIGGER     ?   CREATE TRIGGER inserimento_tra_tabelle AFTER INSERT OR UPDATE ON public."Test" FOR EACH ROW EXECUTE FUNCTION public.inserimento_mutltitabella_test();
 7   DROP TRIGGER inserimento_tra_tabelle ON public."Test";
       public          postgres    false    238    212            ?           2620    26836 1   registro_prenotazione_aula inserisci_prenotazione    TRIGGER     ?   CREATE TRIGGER inserisci_prenotazione BEFORE INSERT ON public.registro_prenotazione_aula FOR EACH ROW EXECUTE FUNCTION public.inserisci_prenotazione();
 J   DROP TRIGGER inserisci_prenotazione ON public.registro_prenotazione_aula;
       public          postgres    false    215    239            ?           2620    34607    Test non_occupa_test    TRIGGER     ?   CREATE TRIGGER non_occupa_test BEFORE INSERT OR UPDATE ON public."Test" FOR EACH ROW EXECUTE FUNCTION public.controllo_aula_non_occupata_test();
 /   DROP TRIGGER non_occupa_test ON public."Test";
       public          postgres    false    212    222            ?           2620    26837    lezione non_occupata    TRIGGER     ?   CREATE TRIGGER non_occupata BEFORE INSERT OR UPDATE ON public.lezione FOR EACH ROW EXECUTE FUNCTION public.controllo_aula_non_occupata_lezione();
 -   DROP TRIGGER non_occupata ON public.lezione;
       public          postgres    false    214    227            ?           2620    26838    aula percentuale_delle_presenze    TRIGGER     ?   CREATE TRIGGER percentuale_delle_presenze AFTER INSERT OR UPDATE ON public.aula FOR EACH ROW EXECUTE FUNCTION public.percentuale_riempimento();
 8   DROP TRIGGER percentuale_delle_presenze ON public.aula;
       public          postgres    false    213    240            ?           2620    26879    corso percentuale_frequenza    TRIGGER     ?   CREATE TRIGGER percentuale_frequenza AFTER INSERT OR UPDATE ON public.corso FOR EACH ROW EXECUTE FUNCTION public.percentuale_frequenza();
 4   DROP TRIGGER percentuale_frequenza ON public.corso;
       public          postgres    false    209    220            ?           2606    26839    corso Corso_ID_Operatore_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.corso
    ADD CONSTRAINT "Corso_ID_Operatore_fkey" FOREIGN KEY ("ID_operatore") REFERENCES public."Operatore"("ID_Operatore");
 I   ALTER TABLE ONLY public.corso DROP CONSTRAINT "Corso_ID_Operatore_fkey";
       public          postgres    false    210    3229    209            ?           2606    26844 
   lezione FK    FK CONSTRAINT     ?   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "FK" FOREIGN KEY (id_corso) REFERENCES public.corso(id_corso) ON UPDATE CASCADE;
 6   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "FK";
       public          postgres    false    3224    214    209            ?           2606    26849    lezione FK_Aula    FK CONSTRAINT     ?   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "FK_Aula" FOREIGN KEY (id_aula) REFERENCES public.aula(id_aula) ON UPDATE CASCADE;
 ;   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "FK_Aula";
       public          postgres    false    3241    214    213            ?           2606    26854    studente FK_Studente    FK CONSTRAINT     ?   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT "FK_Studente" FOREIGN KEY (id_operatore) REFERENCES public."Operatore"("ID_Operatore");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT "FK_Studente";
       public          postgres    false    216    210    3229            ?           2606    26859    Test FK_Test    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "FK_Test" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore"("ID_Operatore") MATCH FULL;
 :   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "FK_Test";
       public          postgres    false    210    212    3229            ?           2606    26864 *   registro_prenotazione_aula FK_prenotazione    FK CONSTRAINT     ?   ALTER TABLE ONLY public.registro_prenotazione_aula
    ADD CONSTRAINT "FK_prenotazione" FOREIGN KEY (id_aula_reference) REFERENCES public.aula(id_aula) ON UPDATE CASCADE;
 V   ALTER TABLE ONLY public.registro_prenotazione_aula DROP CONSTRAINT "FK_prenotazione";
       public          postgres    false    213    3241    215            W   %   x??q??4426153? 2?\??.n??=... (
Y      X   '  x?EQKn?0]?S? ?R?????7?ƀ?X?9R{?ޥ?Lg6?lc??1??????G?Lʣ?\???????l2?(????%??X?o*?2?8F???m????f%? <????{tr????F??RV=c$???
>\??'?2|j?r/?2ZU|?5???M9?????zq;V???A????)]?ݲq??V?_????K??w?3??8??
j+??D?a-z???6-?])?DB???~'?$b2??u?i5?>?????a?v??J?P??]??hY?=R????a??rŷ      Y   ?  x?ݔM??0??ί|?fYq??-K[(?RJ??h?Y??,???!!???|??&{,ۀ?fY???ciD,>}A?*=??Nf?*??/?	~???f??Q???~g??Z?&3??&pJ??Ʒ?4/q?6?V??*?'K?Iܘ?3X?e?
?????m-???????F?A???Eig,G?k??q?]K??0(?[b"?? ??nha??"??7<????ؗweL?e??y?? |WZ?9P??????f?{y??\?pvH??=?f???Ί?=о BLN~mlN? ???P?L?3??3+?ꪉ??S0?L???g!?Ί???????`R?????i??9????{rky???{[a?ƨǨv????>?+y????%T??%t?z? j ??d????L???F ???      Z   @   x??? 1?7s??f????!+J#?F??????ꂚO??i?s8???7O=߼? #;      V   6  x?}TK??F]????	 ??Z?&v? d5?Y?hv??M-f??de??IN?WM???؆ ??????z_?????ܹ???ڼ1ۈ????? ???o??>???'Ƕag?r??W?~?Kd;x??s??(??%??)?!?獤:r?lM?. Pw@??[???(??,5-???&XG6s???Q+?y??<?//6Ǆ??????=h????Ye?g-?1?N?r?=s???mseV;?ۙ??z?ݽ޿?]??k??ٯ?+?=p?H?6?g,?????u4BroΙq??!N?????, Ju??fj?M?CSzk/?'?=G?N↾'\??p
?ӥtt?V?e??v??E??;7?<?ya/2&??=???j?*o???#Z?%?U??!ȵA????n??()?I1?ew _??"]UjD?Pۿ̺8??h???!???G={{??B???&.?Rxx!]ҐÉܐ?gf?5??y???~?K?u?ج??2m?U??)C"Xj??Ht?h?YN?224??C1??j*?},?,^ D?!??	6{????1r?J~b????Ql?\??Ȭ?'??9?σ$?ꮥ?-???no??Y?????n?z??5P??]?٤???dX???IӠ?$?????;?R????"??N_?? ?qr?=^Y? b̨??C??˩?8G5????(b?%?????Zٿ9?֡?1?Z?;?R>?(?[\䔮??`?[)?ύSl?p??GR???A????=?}????Z?3!??gt_?&???q???
?"??Q?Ҧ?z?(??t7%?~??'???<???g?Cuss???e      [   ?  x???Mn?0???\ ???ٵj?B?U?d??E? ?????
{l7.?Fɗ7o?&RJ"?7??ͨ?1y&L??P"(yx??q!?.?e?h?Z?E}j?m=???:??o>*??Uu?j??????+?E??D)?hřP3Ь??rڴ?m}??մ??W. ????2?TYm7?{W%8}??ap?t *p?$y?5????r???A????a!/2L?A8?????4?{?c~)%?,?@???=y??jL_?ye??o??ItE?????LN̜j????OY?7??kv#?#<??F??O?@??1E?B\?b?ɗ???(r0o"VSeʨq?g?c߮?R
q,??L??`R??V8???K<?	IqF!?F?Q???.Q???f?P8????4??I???`*+??$?`?`Ar?????"G??H
??-???e??S,??wS?`S??/T?Kí??3#>xn???[?V?8n??? ?`?D?Hh3f?????z??O&????      \   i   x???[
? ??g?JL???E?w"?=?Y0o3ßV?????*???\??(E!??o?#?B??屋??W??n??S???_???W5???Q?f??a?B?      ]   ?   x?e?Aj?0E?_??	?ƒyi????馛!?t??@U???z?^????&??|??y?5ac?I.o??FƖ???T????UZ[?o?????v?ؠ4j	p??%D?|?93\?C[?a??k??I??8}m?q???>??t???'??Q/?O???-??Q?69??n?ɇOA??ͯ??a????m3?????3?	?^??R?#K?     