PGDMP     $    5                 z            ProgettoDiBasi    14.1    14.1 !               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16394    ProgettoDiBasi    DATABASE     u   CREATE DATABASE "ProgettoDiBasi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United Kingdom.1252';
     DROP DATABASE "ProgettoDiBasi";
                postgres    false                       0    0    DATABASE "ProgettoDiBasi"    COMMENT     �   COMMENT ON DATABASE "ProgettoDiBasi" IS 'Database creato per il progetto di Basi nel quale viene implementato un sistema informativo per la gestione di corsi di formazione.';
                   postgres    false    3355            �            1259    16403    Corso    TABLE     t  CREATE TABLE public."Corso" (
    "Tasso_frequenza" double precision NOT NULL,
    "Tematica" character varying(100) DEFAULT ' '::character varying NOT NULL,
    "ID_Corso" integer NOT NULL,
    "Nome" character varying(20) NOT NULL,
    "Descrizione" character varying(100),
    "Presenze" double precision,
    "Iscritti" integer NOT NULL,
    "ID_Operatore" integer
);
    DROP TABLE public."Corso";
       public         heap    postgres    false            �            1259    16414    Lezione    TABLE       CREATE TABLE public."Lezione" (
    "ID_Lezione" integer NOT NULL,
    "ID_Corso" integer,
    "Descrizione" "char"[],
    "Titolo" "char"[] NOT NULL,
    "Durata" time without time zone NOT NULL,
    "Data_inizio" date[] NOT NULL,
    "Ora_inizio" time without time zone NOT NULL
);
    DROP TABLE public."Lezione";
       public         heap    postgres    false            �            1259    16409 
   Operatore     TABLE     a   CREATE TABLE public."Operatore " (
    "ID_Operatore" integer NOT NULL,
    "ID_Test" integer
);
     DROP TABLE public."Operatore ";
       public         heap    postgres    false            �            1259    16428    Studente    TABLE       CREATE TABLE public."Studente" (
    "ID_Studente" integer NOT NULL,
    "Nome" character varying[] NOT NULL,
    "Cognome" character varying[] NOT NULL,
    "Punteggio_test" integer[] NOT NULL,
    "Tasso_frequenza" integer[] NOT NULL,
    "ID_Operatore" integer
);
    DROP TABLE public."Studente";
       public         heap    postgres    false            �            1259    16421    Tematica    TABLE     �   CREATE TABLE public."Tematica" (
    "Tematica" "char"[] NOT NULL,
    "ID_Corso" integer NOT NULL,
    "Keywords" "char"[],
    "Data" date NOT NULL
);
    DROP TABLE public."Tematica";
       public         heap    postgres    false            �            1259    16435    Test    TABLE     j  CREATE TABLE public."Test" (
    "ID_Test" integer NOT NULL,
    "ID_Operatore" integer NOT NULL,
    "Titolo" character varying[] NOT NULL,
    "Descrizione" character varying[],
    "Durata" time without time zone[] NOT NULL,
    "Ora_inizio" time with time zone NOT NULL,
    "Minimo_punteggio" integer[] NOT NULL,
    "Minimo_presenze" integer[] NOT NULL
);
    DROP TABLE public."Test";
       public         heap    postgres    false                      0    16403    Corso 
   TABLE DATA           �   COPY public."Corso" ("Tasso_frequenza", "Tematica", "ID_Corso", "Nome", "Descrizione", "Presenze", "Iscritti", "ID_Operatore") FROM stdin;
    public          postgres    false    209   �'                 0    16414    Lezione 
   TABLE DATA           }   COPY public."Lezione" ("ID_Lezione", "ID_Corso", "Descrizione", "Titolo", "Durata", "Data_inizio", "Ora_inizio") FROM stdin;
    public          postgres    false    211   T(                 0    16409 
   Operatore  
   TABLE DATA           A   COPY public."Operatore " ("ID_Operatore", "ID_Test") FROM stdin;
    public          postgres    false    210   �(                 0    16428    Studente 
   TABLE DATA           {   COPY public."Studente" ("ID_Studente", "Nome", "Cognome", "Punteggio_test", "Tasso_frequenza", "ID_Operatore") FROM stdin;
    public          postgres    false    213   �(                 0    16421    Tematica 
   TABLE DATA           P   COPY public."Tematica" ("Tematica", "ID_Corso", "Keywords", "Data") FROM stdin;
    public          postgres    false    212   o)                 0    16435    Test 
   TABLE DATA           �   COPY public."Test" ("ID_Test", "ID_Operatore", "Titolo", "Descrizione", "Durata", "Ora_inizio", "Minimo_punteggio", "Minimo_presenze") FROM stdin;
    public          postgres    false    214   �)       q           2606    16408    Corso Corso_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "Corso_pkey" PRIMARY KEY ("ID_Corso");
 >   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "Corso_pkey";
       public            postgres    false    209            w           2606    24600 
   Lezione PK 
   CONSTRAINT     m   ALTER TABLE ONLY public."Lezione"
    ADD CONSTRAINT "PK" PRIMARY KEY ("ID_Lezione") INCLUDE ("ID_Lezione");
 8   ALTER TABLE ONLY public."Lezione" DROP CONSTRAINT "PK";
       public            postgres    false    211            t           2606    24608    Operatore  PK_Operatore 
   CONSTRAINT     ~   ALTER TABLE ONLY public."Operatore "
    ADD CONSTRAINT "PK_Operatore" PRIMARY KEY ("ID_Operatore") INCLUDE ("ID_Operatore");
 E   ALTER TABLE ONLY public."Operatore " DROP CONSTRAINT "PK_Operatore";
       public            postgres    false    210            {           2606    16434    Studente Studente_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."Studente"
    ADD CONSTRAINT "Studente_pkey" PRIMARY KEY ("ID_Studente");
 D   ALTER TABLE ONLY public."Studente" DROP CONSTRAINT "Studente_pkey";
       public            postgres    false    213            ~           2606    16441    Test Test_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "Test_pkey" PRIMARY KEY ("ID_Test");
 <   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "Test_pkey";
       public            postgres    false    214            x           1259    24606    fki_FK    INDEX     D   CREATE INDEX "fki_FK" ON public."Lezione" USING btree ("ID_Corso");
    DROP INDEX public."fki_FK";
       public            postgres    false    211            r           1259    24618    fki_FK_Corso    INDEX     L   CREATE INDEX "fki_FK_Corso" ON public."Corso" USING btree ("ID_Operatore");
 "   DROP INDEX public."fki_FK_Corso";
       public            postgres    false    209            |           1259    24624    fki_FK_Studente    INDEX     R   CREATE INDEX "fki_FK_Studente" ON public."Studente" USING btree ("ID_Operatore");
 %   DROP INDEX public."fki_FK_Studente";
       public            postgres    false    213            y           1259    24630    fki_FK_Tematica    INDEX     N   CREATE INDEX "fki_FK_Tematica" ON public."Tematica" USING btree ("ID_Corso");
 %   DROP INDEX public."fki_FK_Tematica";
       public            postgres    false    212                       1259    24636    fki_FK_Test    INDEX     J   CREATE INDEX "fki_FK_Test" ON public."Test" USING btree ("ID_Operatore");
 !   DROP INDEX public."fki_FK_Test";
       public            postgres    false    214            u           1259    24582    fki_ID_Operatore    INDEX     U   CREATE INDEX "fki_ID_Operatore" ON public."Operatore " USING btree ("ID_Operatore");
 &   DROP INDEX public."fki_ID_Operatore";
       public            postgres    false    210            �           2606    24601 
   Lezione FK    FK CONSTRAINT     z   ALTER TABLE ONLY public."Lezione"
    ADD CONSTRAINT "FK" FOREIGN KEY ("ID_Corso") REFERENCES public."Corso"("ID_Corso");
 8   ALTER TABLE ONLY public."Lezione" DROP CONSTRAINT "FK";
       public          postgres    false    209    3185    211            �           2606    24613    Corso FK_Corso    FK CONSTRAINT     �   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "FK_Corso" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore "("ID_Operatore");
 <   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "FK_Corso";
       public          postgres    false    209    210    3188            �           2606    24619    Studente FK_Studente    FK CONSTRAINT     �   ALTER TABLE ONLY public."Studente"
    ADD CONSTRAINT "FK_Studente" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore "("ID_Operatore");
 B   ALTER TABLE ONLY public."Studente" DROP CONSTRAINT "FK_Studente";
       public          postgres    false    213    3188    210            �           2606    24625    Tematica FK_Tematica    FK CONSTRAINT     �   ALTER TABLE ONLY public."Tematica"
    ADD CONSTRAINT "FK_Tematica" FOREIGN KEY ("ID_Corso") REFERENCES public."Corso"("ID_Corso");
 B   ALTER TABLE ONLY public."Tematica" DROP CONSTRAINT "FK_Tematica";
       public          postgres    false    212    3185    209            �           2606    24642    Test FK_Test    FK CONSTRAINT     �   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "FK_Test" FOREIGN KEY ("ID_Operatore") REFERENCES public."Operatore "("ID_Operatore") NOT VALID;
 :   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "FK_Test";
       public          postgres    false    214    3188    210               �   x�U�=�0F��> B�o�V1u q�.����I��0pz"ъ Oϟ�>���Zh&��E�������� l����.��Dd*3��Tu���QUu�n+p]���ao��\xDUy�.�i������{c�K�70:C�fB����#j9�BkI��U�qAgQxf0q�:�}�$�V]\         h   x���K
�0��ur��$i��\n�I��}PP��v�~�7*K�2W��PQ�8$=֘��B��__�����)>���p}�i?Zдo%뭻ݸ�60���28            x������ � �         v   x�3�v�I,�,.N����/JO�+.I-�� 8Əˈ�:$#?7�(����T�"mԙX��;�$&g�d��7�/�ir��)�G�4��*��L�í��?�D��DT�c���� *0@�         ^   x��v��453��N���)�I�)�)�ɬ�4202�5��50����4426���IŐ1162�. �.�IC����073�]��	�)(�1z\\\ 8��         N   x�3444�4�I-.1��V1R2KK��sJK�2��R��r�V@T�ih airV���Mk�b���� ��r     