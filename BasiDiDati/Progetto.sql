PGDMP     0    ;                 z            Progetto    13.4    13.4     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16405    Progetto    DATABASE     f   CREATE DATABASE "Progetto" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';
    DROP DATABASE "Progetto";
                postgres    false            �            1259    16406    Corso    TABLE     R  CREATE TABLE public."Corso" (
    "Tasso_frequenza" double precision NOT NULL,
    "Tematica" character varying(100) DEFAULT ' '::character varying NOT NULL,
    "ID" integer NOT NULL,
    "Nome" character varying(20) NOT NULL,
    "Descrizione" character varying(100),
    "Presenze" double precision,
    "Iscritti" integer NOT NULL
);
    DROP TABLE public."Corso";
       public         heap    postgres    false            �            1259    16410    Lezione    TABLE     !  CREATE TABLE public."Lezione" (
    "ID_Lezione" integer NOT NULL,
    "ID_Corso" integer,
    "Descrizione" "char"[],
    "Titolo" "char"[] NOT NULL,
    "Durata" time without time zone NOT NULL,
    "Data_inizio" date[] NOT NULL,
    "Ora_inizio" timestamp without time zone NOT NULL
);
    DROP TABLE public."Lezione";
       public         heap    postgres    false            �            1259    16416 
   Operatore     TABLE     J   CREATE TABLE public."Operatore " (
    "ID_Operatore" integer NOT NULL
);
     DROP TABLE public."Operatore ";
       public         heap    postgres    false            �            1259    16419    Studente    TABLE     �   CREATE TABLE public."Studente" (
    "ID_Studente" integer NOT NULL,
    "Nome" character varying[] NOT NULL,
    "Cognome" character varying[] NOT NULL,
    "Punteggio_test" integer[] NOT NULL,
    "Tasso_frequenza" integer[] NOT NULL
);
    DROP TABLE public."Studente";
       public         heap    postgres    false            �            1259    16425    Tematica    TABLE     �   CREATE TABLE public."Tematica" (
    "Tematica" "char"[] NOT NULL,
    "ID_Corso" integer NOT NULL,
    "Keywords" "char"[],
    "Data" date NOT NULL
);
    DROP TABLE public."Tematica";
       public         heap    postgres    false            �            1259    16431    Test    TABLE     o  CREATE TABLE public."Test" (
    "ID_Test" integer NOT NULL,
    "ID_Operatore" integer NOT NULL,
    "Titolo" character varying[] NOT NULL,
    "Descrizione" character varying[],
    "Durata" time without time zone[] NOT NULL,
    "Ora_inizio" timestamp with time zone NOT NULL,
    "Minimo_punteggio" integer[] NOT NULL,
    "Minimo_presenze" integer[] NOT NULL
);
    DROP TABLE public."Test";
       public         heap    postgres    false            �          0    16406    Corso 
   TABLE DATA           u   COPY public."Corso" ("Tasso_frequenza", "Tematica", "ID", "Nome", "Descrizione", "Presenze", "Iscritti") FROM stdin;
    public          postgres    false    200   7       �          0    16410    Lezione 
   TABLE DATA           }   COPY public."Lezione" ("ID_Lezione", "ID_Corso", "Descrizione", "Titolo", "Durata", "Data_inizio", "Ora_inizio") FROM stdin;
    public          postgres    false    201   �       �          0    16416 
   Operatore  
   TABLE DATA           6   COPY public."Operatore " ("ID_Operatore") FROM stdin;
    public          postgres    false    202           �          0    16419    Studente 
   TABLE DATA           k   COPY public."Studente" ("ID_Studente", "Nome", "Cognome", "Punteggio_test", "Tasso_frequenza") FROM stdin;
    public          postgres    false    203   )        �          0    16425    Tematica 
   TABLE DATA           P   COPY public."Tematica" ("Tematica", "ID_Corso", "Keywords", "Data") FROM stdin;
    public          postgres    false    204   �        �          0    16431    Test 
   TABLE DATA           �   COPY public."Test" ("ID_Test", "ID_Operatore", "Titolo", "Descrizione", "Durata", "Ora_inizio", "Minimo_punteggio", "Minimo_presenze") FROM stdin;
    public          postgres    false    205   3!       :           2606    16438    Corso Corso_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "Corso_pkey" PRIMARY KEY ("ID");
 >   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "Corso_pkey";
       public            postgres    false    200            <           2606    16440    Lezione Lezione_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."Lezione"
    ADD CONSTRAINT "Lezione_pkey" PRIMARY KEY ("ID_Lezione");
 B   ALTER TABLE ONLY public."Lezione" DROP CONSTRAINT "Lezione_pkey";
       public            postgres    false    201            ?           2606    16442    Operatore  Operatore _pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."Operatore "
    ADD CONSTRAINT "Operatore _pkey" PRIMARY KEY ("ID_Operatore");
 H   ALTER TABLE ONLY public."Operatore " DROP CONSTRAINT "Operatore _pkey";
       public            postgres    false    202            B           2606    16444    Studente Studente_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."Studente"
    ADD CONSTRAINT "Studente_pkey" PRIMARY KEY ("ID_Studente");
 D   ALTER TABLE ONLY public."Studente" DROP CONSTRAINT "Studente_pkey";
       public            postgres    false    203            D           2606    16446    Tematica Tematica_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."Tematica"
    ADD CONSTRAINT "Tematica_pkey" PRIMARY KEY ("Tematica", "ID_Corso");
 D   ALTER TABLE ONLY public."Tematica" DROP CONSTRAINT "Tematica_pkey";
       public            postgres    false    204    204            G           2606    16448    Test Test_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "Test_pkey" PRIMARY KEY ("ID_Test");
 <   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "Test_pkey";
       public            postgres    false    205            =           1259    16450    fki_FK    INDEX     D   CREATE INDEX "fki_FK" ON public."Lezione" USING btree ("ID_Corso");
    DROP INDEX public."fki_FK";
       public            postgres    false    201            E           1259    16451    fki_FK_Tematica    INDEX     N   CREATE INDEX "fki_FK_Tematica" ON public."Tematica" USING btree ("ID_Corso");
 %   DROP INDEX public."fki_FK_Tematica";
       public            postgres    false    204            H           1259    16452    fki_FK_Test    INDEX     J   CREATE INDEX "fki_FK_Test" ON public."Test" USING btree ("ID_Operatore");
 !   DROP INDEX public."fki_FK_Test";
       public            postgres    false    205            @           1259    16449    fki_ID_Operatore    INDEX     U   CREATE INDEX "fki_ID_Operatore" ON public."Operatore " USING btree ("ID_Operatore");
 &   DROP INDEX public."fki_ID_Operatore";
       public            postgres    false    202            I           2606    16453    Test FK_Test    FK CONSTRAINT     �   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "FK_Test" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore "("ID_Operatore");
 :   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "FK_Test";
       public          postgres    false    2879    205    202            �   �   x�U�=�0�g�> B�?b��: q SBd�$UZ8=E�R:~~z߳��[1��,/���S�c�;���/B�'���F$`��Њ5�HP��a��O�i��fiu����{���3��`#9G~���I���g��@q6#��u�L�YM]%��[O�#�Kӟ�WJ}�Z�      �      x������ � �      �      x������ � �      �   �   x�3426����M,���H�I�2������(]�s��)��CH�[X %S����E�H--���s�2!���E�y�%�E���-�*��L�:�$&g�d�#+1162�N,�ơ F��� &�@C      �   i   x�U�;� D��,���_ZRxCBBA�n��]J2��͈/�xI"<�Bl�uv�,Q:�H2�&�EhL�\�?\x�[�(�.�T��oMԧO;5��c~�_#�      �      x������ � �     