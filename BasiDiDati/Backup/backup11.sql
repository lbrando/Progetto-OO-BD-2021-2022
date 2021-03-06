PGDMP                         z            proprogettino    14.1    14.1 ?    P           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            R           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            S           1262    26242    proprogettino    DATABASE     r   CREATE DATABASE proprogettino WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United Kingdom.1252';
    DROP DATABASE proprogettino;
                postgres    false            ?            1255    26244    conferma_prenotazione()    FUNCTION     b  CREATE FUNCTION public.conferma_prenotazione() RETURNS trigger
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
       public          postgres    false            ?            1255    26245    controllo_tasso_frequenza()    FUNCTION     ?   CREATE FUNCTION public.controllo_tasso_frequenza() RETURNS trigger
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
       public          postgres    false            ?            1255    26247 #   inserimento_mutltitabella_lezione()    FUNCTION        CREATE FUNCTION public.inserimento_mutltitabella_lezione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   

 BEGIN    

INSERT INTO Public."Registro_prenotazione_aula" 
	VALUES( NEW.data_inizio, NEW.ora_inizio,NEW.id_aula);

RETURN NEW;   
END;     $$;
 :   DROP FUNCTION public.inserimento_mutltitabella_lezione();
       public          postgres    false            ?            1255    26248     inserimento_mutltitabella_test()    FUNCTION     M  CREATE FUNCTION public.inserimento_mutltitabella_test() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   
   
 BEGIN    

INSERT INTO Public."Registro_prenotazione_aula" (data_prenotazione,ora, id_lezione_or_test,id_aula_reference)
	VALUES( NEW.data_test, NEW.ora_inizio,NEW.id_test, NEW.id_aula_test );

RETURN NEW;   
END;   
$$;
 7   DROP FUNCTION public.inserimento_mutltitabella_test();
       public          postgres    false            ?            1255    26249    inserisci_prenotazione()    FUNCTION     ?  CREATE FUNCTION public.inserisci_prenotazione() RETURNS trigger
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
       public          postgres    false            ?            1259    26256    Corso    TABLE     ?  CREATE TABLE public."Corso" (
    "Tasso_frequenza" double precision NOT NULL,
    "Tematica" character varying(100) DEFAULT ' '::character varying NOT NULL,
    "ID_Corso" integer NOT NULL,
    "Nome" character varying(50) NOT NULL,
    "Descrizione" character varying(500),
    "Presenze" double precision,
    "Iscritti" integer NOT NULL,
    "ID_Operatore" character varying,
    "Numero Lezioni" integer,
    "ID_STUDENTE" integer,
    "NUM_STUDENTI" integer
);
    DROP TABLE public."Corso";
       public         heap    postgres    false            ?            1259    26268 	   Operatore    TABLE     S   CREATE TABLE public."Operatore" (
    "ID_Operatore" character varying NOT NULL
);
    DROP TABLE public."Operatore";
       public         heap    postgres    false            ?            1259    26279    Tematica    TABLE     ?   CREATE TABLE public."Tematica" (
    tematica character varying NOT NULL,
    id_corso integer NOT NULL,
    keywords character varying
);
    DROP TABLE public."Tematica";
       public         heap    postgres    false            T           0    0    TABLE "Tematica"    ACL     0   GRANT ALL ON TABLE public."Tematica" TO PUBLIC;
          public          postgres    false    214            ?            1259    26284    Test    TABLE     ?  CREATE TABLE public."Test" (
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
       public         heap    postgres    false            ?            1259    26250    aula    TABLE     ?   CREATE TABLE public.aula (
    num_max_posti integer NOT NULL,
    num_presenti integer,
    "Percentuale_Occupata" double precision,
    id_aula character varying NOT NULL,
    CONSTRAINT posti_max_check CHECK ((num_max_posti >= num_presenti))
);
    DROP TABLE public.aula;
       public         heap    postgres    false            ?            1259    26262    lezione    TABLE     R  CREATE TABLE public.lezione (
    id_lezione integer NOT NULL,
    id_corso integer,
    durata time without time zone NOT NULL,
    data_inizio date[] NOT NULL,
    ora_inizio time without time zone NOT NULL,
    "num_Iscritti" integer,
    tasso_frequenza double precision,
    id_operatore character varying,
    numero_lezioni integer,
    id_aula character varying,
    titolo character varying,
    descrizione character varying,
    CONSTRAINT "Lezione_Tasso_Frequenza_check" CHECK (((tasso_frequenza >= (0.00)::double precision) AND (tasso_frequenza <= (100.00)::double precision)))
);
    DROP TABLE public.lezione;
       public         heap    postgres    false            ?            1259    26289    registro_prenotazione_aula    TABLE     ?   CREATE TABLE public.registro_prenotazione_aula (
    data_prenotazione date[] NOT NULL,
    ora time with time zone NOT NULL,
    id_aula_reference character varying,
    check_status character varying[]
);
 .   DROP TABLE public.registro_prenotazione_aula;
       public         heap    postgres    false            U           0    0     TABLE registro_prenotazione_aula    ACL     E   REVOKE ALL ON TABLE public.registro_prenotazione_aula FROM postgres;
          public          postgres    false    216            ?            1259    26273    studente    TABLE     ?  CREATE TABLE public.studente (
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
       public         heap    postgres    false            V           0    0    COLUMN studente.id_corso    COMMENT     K   COMMENT ON COLUMN public.studente.id_corso IS 'Corso a cui sono iscritti';
          public          postgres    false    213            ?            1259    26294    view_controlla_frequenza    VIEW     ?  CREATE VIEW public.view_controlla_frequenza AS
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
       public          postgres    false    211    211    211    211    211    211    211            ?            1259    26298    view_controlla_voti_frequenza    VIEW     Y  CREATE VIEW public.view_controlla_voti_frequenza AS
 SELECT studente.id_studente AS "ID_Studente",
    studente.nome AS "Nome",
    studente.cognome AS "Cognome",
    studente.tasso_frequenza,
    studente.punteggio_test
   FROM public.studente
  WHERE ((studente.punteggio_test >= 60) AND (studente.tasso_frequenza >= (75)::double precision));
 0   DROP VIEW public.view_controlla_voti_frequenza;
       public          postgres    false    213    213    213    213    213            ?            1259    26302    view_visualizza_studenti    VIEW     ?   CREATE VIEW public.view_visualizza_studenti AS
 SELECT studente.id_studente,
    studente.tasso_frequenza,
    studente.id_corso,
    studente.cognome
   FROM public.studente;
 +   DROP VIEW public.view_visualizza_studenti;
       public          postgres    false    213    213    213    213            G          0    26256    Corso 
   TABLE DATA           ?   COPY public."Corso" ("Tasso_frequenza", "Tematica", "ID_Corso", "Nome", "Descrizione", "Presenze", "Iscritti", "ID_Operatore", "Numero Lezioni", "ID_STUDENTE", "NUM_STUDENTI") FROM stdin;
    public          postgres    false    210   JY       I          0    26268 	   Operatore 
   TABLE DATA           5   COPY public."Operatore" ("ID_Operatore") FROM stdin;
    public          postgres    false    212   e\       K          0    26279    Tematica 
   TABLE DATA           B   COPY public."Tematica" (tematica, id_corso, keywords) FROM stdin;
    public          postgres    false    214   ?\       L          0    26284    Test 
   TABLE DATA           ?   COPY public."Test" (id_test, "ID_Operatore", "Titolo", "Descrizione", "Durata", ora_inizio, "Minimo_punteggio", "Minimo_presenze", data_test, id_aula_test) FROM stdin;
    public          postgres    false    215   ?]       F          0    26250    aula 
   TABLE DATA           \   COPY public.aula (num_max_posti, num_presenti, "Percentuale_Occupata", id_aula) FROM stdin;
    public          postgres    false    209   ]_       H          0    26262    lezione 
   TABLE DATA           ?   COPY public.lezione (id_lezione, id_corso, durata, data_inizio, ora_inizio, "num_Iscritti", tasso_frequenza, id_operatore, numero_lezioni, id_aula, titolo, descrizione) FROM stdin;
    public          postgres    false    211   ?_       M          0    26289    registro_prenotazione_aula 
   TABLE DATA           m   COPY public.registro_prenotazione_aula (data_prenotazione, ora, id_aula_reference, check_status) FROM stdin;
    public          postgres    false    216   Ra       J          0    26273    studente 
   TABLE DATA           w   COPY public.studente (id_studente, nome, cognome, tasso_frequenza, id_operatore, id_corso, punteggio_test) FROM stdin;
    public          postgres    false    213   ?a       ?           2606    26311 ,   registro_prenotazione_aula Aula_non_occupata 
   CONSTRAINT     ?   ALTER TABLE ONLY public.registro_prenotazione_aula
    ADD CONSTRAINT "Aula_non_occupata" UNIQUE (data_prenotazione, ora, id_aula_reference) INCLUDE (data_prenotazione, ora, id_aula_reference);
 X   ALTER TABLE ONLY public.registro_prenotazione_aula DROP CONSTRAINT "Aula_non_occupata";
       public            postgres    false    216    216    216            ?           2606    26313    Corso Corso_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "Corso_pkey" PRIMARY KEY ("ID_Corso");
 >   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "Corso_pkey";
       public            postgres    false    210            ?           2606    26315 .   lezione Data_od_ora_in_cui_aula_già_prenotata 
   CONSTRAINT     ?   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "Data_od_ora_in_cui_aula_già_prenotata" UNIQUE (id_aula, data_inizio, ora_inizio);
 Z   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "Data_od_ora_in_cui_aula_già_prenotata";
       public            postgres    false    211    211    211            ?           2606    26317 
   lezione PK 
   CONSTRAINT     g   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "PK" PRIMARY KEY (id_lezione) INCLUDE (id_lezione);
 6   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "PK";
       public            postgres    false    211            ?           2606    26319    aula PK_Aula 
   CONSTRAINT     c   ALTER TABLE ONLY public.aula
    ADD CONSTRAINT "PK_Aula" PRIMARY KEY (id_aula) INCLUDE (id_aula);
 8   ALTER TABLE ONLY public.aula DROP CONSTRAINT "PK_Aula";
       public            postgres    false    209            ?           2606    26321    Operatore PK_Operatore 
   CONSTRAINT     }   ALTER TABLE ONLY public."Operatore"
    ADD CONSTRAINT "PK_Operatore" PRIMARY KEY ("ID_Operatore") INCLUDE ("ID_Operatore");
 D   ALTER TABLE ONLY public."Operatore" DROP CONSTRAINT "PK_Operatore";
       public            postgres    false    212            ?           2606    26323    studente Studente_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT "Studente_pkey" PRIMARY KEY (id_studente);
 B   ALTER TABLE ONLY public.studente DROP CONSTRAINT "Studente_pkey";
       public            postgres    false    213            ?           2606    26325    Tematica Tematica_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public."Tematica"
    ADD CONSTRAINT "Tematica_pk" PRIMARY KEY (tematica) INCLUDE (tematica);
 B   ALTER TABLE ONLY public."Tematica" DROP CONSTRAINT "Tematica_pk";
       public            postgres    false    214            ?           2606    26327    Test Test_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "Test_pkey" PRIMARY KEY (id_test);
 <   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "Test_pkey";
       public            postgres    false    215            ?           2606    26329    Corso Unique_Corso 
   CONSTRAINT     W   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "Unique_Corso" UNIQUE ("Tematica");
 @   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "Unique_Corso";
       public            postgres    false    210            ?           2606    26331    Test unicita_test 
   CONSTRAINT     v   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT unicita_test UNIQUE (id_aula_test, data_test, id_test, ora_inizio);
 =   ALTER TABLE ONLY public."Test" DROP CONSTRAINT unicita_test;
       public            postgres    false    215    215    215    215            ?           2606    26333    studente uno_studente_un_corso 
   CONSTRAINT     j   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT uno_studente_un_corso UNIQUE (id_studente, id_corso);
 H   ALTER TABLE ONLY public.studente DROP CONSTRAINT uno_studente_un_corso;
       public            postgres    false    213    213            ?           1259    26338    fki_FK    INDEX     @   CREATE INDEX "fki_FK" ON public.lezione USING btree (id_corso);
    DROP INDEX public."fki_FK";
       public            postgres    false    211            ?           1259    26339    fki_FK_Aula    INDEX     D   CREATE INDEX "fki_FK_Aula" ON public.lezione USING btree (id_aula);
 !   DROP INDEX public."fki_FK_Aula";
       public            postgres    false    211            ?           1259    26340    fki_FK_Corso    INDEX     L   CREATE INDEX "fki_FK_Corso" ON public."Corso" USING btree ("ID_Operatore");
 "   DROP INDEX public."fki_FK_Corso";
       public            postgres    false    210            ?           1259    26341    fki_FK_Studente    INDEX     N   CREATE INDEX "fki_FK_Studente" ON public.studente USING btree (id_operatore);
 %   DROP INDEX public."fki_FK_Studente";
       public            postgres    false    213            ?           1259    26342    fki_FK_Tematica    INDEX     L   CREATE INDEX "fki_FK_Tematica" ON public."Tematica" USING btree (id_corso);
 %   DROP INDEX public."fki_FK_Tematica";
       public            postgres    false    214            ?           1259    26343    fki_FK_Test    INDEX     J   CREATE INDEX "fki_FK_Test" ON public."Test" USING btree ("ID_Operatore");
 !   DROP INDEX public."fki_FK_Test";
       public            postgres    false    215            ?           1259    26345    fki_FK_prenotazione    INDEX     i   CREATE INDEX "fki_FK_prenotazione" ON public.registro_prenotazione_aula USING btree (id_aula_reference);
 )   DROP INDEX public."fki_FK_prenotazione";
       public            postgres    false    216            ?           1259    26347    fki_ID_Operatore    INDEX     T   CREATE INDEX "fki_ID_Operatore" ON public."Operatore" USING btree ("ID_Operatore");
 &   DROP INDEX public."fki_ID_Operatore";
       public            postgres    false    212            ?           1259    26348    fki_fk_aula    INDEX     F   CREATE INDEX fki_fk_aula ON public."Test" USING btree (id_aula_test);
    DROP INDEX public.fki_fk_aula;
       public            postgres    false    215            ?           1259    26351    fki_fk_votii    INDEX     K   CREATE INDEX fki_fk_votii ON public.studente USING btree (punteggio_test);
     DROP INDEX public.fki_fk_votii;
       public            postgres    false    213            ?           2620    26352 0   registro_prenotazione_aula conferma_prenotazione    TRIGGER     ?   CREATE TRIGGER conferma_prenotazione BEFORE UPDATE ON public.registro_prenotazione_aula FOR EACH ROW EXECUTE FUNCTION public.conferma_prenotazione();
 I   DROP TRIGGER conferma_prenotazione ON public.registro_prenotazione_aula;
       public          postgres    false    231    216            ?           2620    26354 !   lezione controllo_tasso_frequenza    TRIGGER     ?   CREATE TRIGGER controllo_tasso_frequenza AFTER INSERT OR UPDATE OF tasso_frequenza ON public.lezione FOR EACH STATEMENT EXECUTE FUNCTION public.controllo_tasso_frequenza();
 :   DROP TRIGGER controllo_tasso_frequenza ON public.lezione;
       public          postgres    false    211    232    211            ?           2620    26356    Test inserimento_tra_tabelle    TRIGGER     ?   CREATE TRIGGER inserimento_tra_tabelle AFTER INSERT OR UPDATE ON public."Test" FOR EACH ROW EXECUTE FUNCTION public.inserimento_mutltitabella_test();
 7   DROP TRIGGER inserimento_tra_tabelle ON public."Test";
       public          postgres    false    215    233            ?           2620    26357 1   registro_prenotazione_aula inserisci_prenotazione    TRIGGER     ?   CREATE TRIGGER inserisci_prenotazione BEFORE INSERT ON public.registro_prenotazione_aula FOR EACH ROW EXECUTE FUNCTION public.inserisci_prenotazione();
 J   DROP TRIGGER inserisci_prenotazione ON public.registro_prenotazione_aula;
       public          postgres    false    234    216            ?           2606    26359    Corso Corso_ID_Operatore_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "Corso_ID_Operatore_fkey" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore"("ID_Operatore");
 K   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "Corso_ID_Operatore_fkey";
       public          postgres    false    212    3226    210            ?           2606    26364 
   lezione FK    FK CONSTRAINT     ?   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "FK" FOREIGN KEY (id_corso) REFERENCES public."Corso"("ID_Corso") ON UPDATE CASCADE;
 6   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "FK";
       public          postgres    false    3215    210    211            ?           2606    26369    lezione FK_Aula    FK CONSTRAINT     ?   ALTER TABLE ONLY public.lezione
    ADD CONSTRAINT "FK_Aula" FOREIGN KEY (id_aula) REFERENCES public.aula(id_aula) ON UPDATE CASCADE;
 ;   ALTER TABLE ONLY public.lezione DROP CONSTRAINT "FK_Aula";
       public          postgres    false    211    3213    209            ?           2606    26374    studente FK_Studente    FK CONSTRAINT     ?   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT "FK_Studente" FOREIGN KEY (id_operatore) REFERENCES public."Operatore"("ID_Operatore");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT "FK_Studente";
       public          postgres    false    212    3226    213            ?           2606    26379    Test FK_Test    FK CONSTRAINT     ?   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "FK_Test" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore"("ID_Operatore") MATCH FULL;
 :   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "FK_Test";
       public          postgres    false    3226    215    212            ?           2606    26384 *   registro_prenotazione_aula FK_prenotazione    FK CONSTRAINT     ?   ALTER TABLE ONLY public.registro_prenotazione_aula
    ADD CONSTRAINT "FK_prenotazione" FOREIGN KEY (id_aula_reference) REFERENCES public.aula(id_aula) ON UPDATE CASCADE;
 V   ALTER TABLE ONLY public.registro_prenotazione_aula DROP CONSTRAINT "FK_prenotazione";
       public          postgres    false    3213    216    209            G     x??T?n?@<{?b? ?6??p?H+		?S.?v???x??c{?S8!?#P=v??$?|ϣ??????ʵ?#W?եћF̸eV?ʚ????21Q???)d?J??|?d6>8	l?Z?{?a??dGfM??Lb????%]7l-!???f?#s?nҰiŵ??? Y?)?>??Vb*X?ű??C??L??t????GD?g?A?-K?ċj?????????٫?o?bQ???ٲ??-?U'{r?-?s%????? ??????Hq??%C\
??;??@3?2???XN<ǁ????*??I???<9? 	Ձ?9?ʑ$??o???Q????O??D???vPG???t??Gce? ???ѲG?>^,???m?PwWT?N??}??u4P0??i??X?ӻ?Pު}林R???D5N\;?o?? n???'\??pJ??_??Vu?໶??Ņi??:7#rJQO5x?wF??????Q??!ȶ^??
?I??ގќ????Al?z,T/Dz??t?>???u??Oŋt??$Vv;=j???R8??D?C{??C)'???i|V????y?|?ģ]?&???eꓒ=<?嘕?(?z???(????K????Y?U_?AI?h?>?Mv
S???h???}??sñG8??IAZ?FG??3N????_.?W?h?	:?? S'I?e???E??1??s+????????0??!??|?ۀ?=??i]?aX????z0?՗??^
??N?`?u??J?Ң?8?"?%81FY?uN܏??????q???f ??Z
      I   %   x??q??4426153? 2?\??.n??=... (
Y      K   '  x?EQKn?0]?S? ?R?????7?ƀ?X?9R{?ޥ?Lg6?lc??1??????G?Lʣ?\???????l2?(????%??X?o*?2?8F???m????f%? <????{tr????F??RV=c$???
>\??'?2|j?r/?2ZU|?5???M9?????zq;V???A????)]?ݲq??V?_????K??w?3??8??
j+??D?a-z???6-?])?DB???~'?$b2??u?i5?>?????a?v??J?P??]??hY?=R????a??rŷ      L   |  x??TKK1>???a??2?t??MQA??K?;?٤??CK???>???(">&???D"bvs?B?rT]?/'????? OζNu?Z?5Tl>??H?C?PG??_;?B4Pۆk????/Y?łA+X8;?ԩ?????r???&?[????U??j????G=?۫o?]?????3??59? ?3?@ֱ????m_?Pyr5?x
??ذ-??a??y?f'xPh?8Pl%34????	L?Ҽ$?r''?	L???d???{??Dk+h$"*?T:?] =??2ӝ?ԝ%by????ܩ/&???£??c?Q?ڎL?N??rC:u??vo?!o?cޣ??7?^??K1D9D??'?????%????P?>?}?T???<??(lӟ      F   5   x?ɱ ?x?o9?Ӌ?"??O?`&U?Ō$???e?>
???G?"???      H   ?  x???Mn?0????@???̮U?U?d?F4BJAJ?jջ?i???R7???x?͘*?Z?P_?k?k0?
*???%????"?SV?F?{V?????f?u۽????G{ػ??T?~?RˀZ?9?6#T?R? Z?2??U?O?{??&??H??{???c?r??DT?B?)W$k?x???%?X?a}Nvt?r??Q?A,',??.S9?T??R0?]3Љ?"?I1u?q?j???VBl?T?LEWN??@????????Tr"?L??ʘ??S٥?>?8?2J*?3?}׀?V??5??Yn4???(?K?V?X	??U %??n W ?W&dv??w?k?N?V??̼?l?&?T??	s.ް&pV|^)(???8? ?L??E?ڀ?W????????ƾU ??m@???b?)??Q:??      M   U   x????	?0???n+?2????t?{?????>~???]?O???B??6W??????y?+-F,?y??????V??????0?      J   ?   x?e?Aj?0E?_??	?ƒyi????馛!?t??@U???z?^????&??|??y?5ac?I.o??FƖ???T????UZ[?o?????v?ؠ4j	p??%D?|?93\?C[?a??k??I??8}m?q???>??t???'??Q/?O???-??Q?69??n?ɇOA??ͯ??a????m3?????3?	?^??R?#K?     