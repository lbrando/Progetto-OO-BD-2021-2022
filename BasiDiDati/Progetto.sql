PGDMP         
                 z            ProgettoDiBasi    14.1    14.1                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16394    ProgettoDiBasi    DATABASE     u   CREATE DATABASE "ProgettoDiBasi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United Kingdom.1252';
     DROP DATABASE "ProgettoDiBasi";
                postgres    false                       0    0    DATABASE "ProgettoDiBasi"    COMMENT     �   COMMENT ON DATABASE "ProgettoDiBasi" IS 'Database creato per il progetto di Basi nel quale viene implementato un sistema informativo per la gestione di corsi di formazione.';
                   postgres    false    3347            �            1259    16403    Corso    TABLE     R  CREATE TABLE public."Corso" (
    "Tasso_frequenza" double precision NOT NULL,
    "Tematica" character varying(100) DEFAULT ' '::character varying NOT NULL,
    "ID" integer NOT NULL,
    "Nome" character varying(20) NOT NULL,
    "Descrizione" character varying(100),
    "Presenze" double precision,
    "Iscritti" integer NOT NULL
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
   Operatore     TABLE     J   CREATE TABLE public."Operatore " (
    "ID_Operatore" integer NOT NULL
);
     DROP TABLE public."Operatore ";
       public         heap    postgres    false            �            1259    16428    Studente    TABLE     �   CREATE TABLE public."Studente" (
    "ID_Studente" integer NOT NULL,
    "Nome" character varying[] NOT NULL,
    "Cognome" character varying[] NOT NULL,
    "Punteggio_test" integer[] NOT NULL,
    "Tasso_frequenza" integer[] NOT NULL
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
       public         heap    postgres    false                      0    16403    Corso 
   TABLE DATA           u   COPY public."Corso" ("Tasso_frequenza", "Tematica", "ID", "Nome", "Descrizione", "Presenze", "Iscritti") FROM stdin;
    public          postgres    false    209   !       
          0    16414    Lezione 
   TABLE DATA           }   COPY public."Lezione" ("ID_Lezione", "ID_Corso", "Descrizione", "Titolo", "Durata", "Data_inizio", "Ora_inizio") FROM stdin;
    public          postgres    false    211   �       	          0    16409 
   Operatore  
   TABLE DATA           6   COPY public."Operatore " ("ID_Operatore") FROM stdin;
    public          postgres    false    210   Q                 0    16428    Studente 
   TABLE DATA           k   COPY public."Studente" ("ID_Studente", "Nome", "Cognome", "Punteggio_test", "Tasso_frequenza") FROM stdin;
    public          postgres    false    213   n                 0    16421    Tematica 
   TABLE DATA           P   COPY public."Tematica" ("Tematica", "ID_Corso", "Keywords", "Data") FROM stdin;
    public          postgres    false    212   �                 0    16435    Test 
   TABLE DATA           �   COPY public."Test" ("ID_Test", "ID_Operatore", "Titolo", "Descrizione", "Durata", "Ora_inizio", "Minimo_punteggio", "Minimo_presenze") FROM stdin;
    public          postgres    false    214   `       q           2606    16408    Corso Corso_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."Corso"
    ADD CONSTRAINT "Corso_pkey" PRIMARY KEY ("ID");
 >   ALTER TABLE ONLY public."Corso" DROP CONSTRAINT "Corso_pkey";
       public            postgres    false    209            t           2606    24600 
   Lezione PK 
   CONSTRAINT     m   ALTER TABLE ONLY public."Lezione"
    ADD CONSTRAINT "PK" PRIMARY KEY ("ID_Lezione") INCLUDE ("ID_Lezione");
 8   ALTER TABLE ONLY public."Lezione" DROP CONSTRAINT "PK";
       public            postgres    false    211            y           2606    16434    Studente Studente_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."Studente"
    ADD CONSTRAINT "Studente_pkey" PRIMARY KEY ("ID_Studente");
 D   ALTER TABLE ONLY public."Studente" DROP CONSTRAINT "Studente_pkey";
       public            postgres    false    213            w           2606    16427    Tematica Tematica_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."Tematica"
    ADD CONSTRAINT "Tematica_pkey" PRIMARY KEY ("Tematica", "ID_Corso");
 D   ALTER TABLE ONLY public."Tematica" DROP CONSTRAINT "Tematica_pkey";
       public            postgres    false    212    212            {           2606    16441    Test Test_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Test"
    ADD CONSTRAINT "Test_pkey" PRIMARY KEY ("ID_Test");
 <   ALTER TABLE ONLY public."Test" DROP CONSTRAINT "Test_pkey";
       public            postgres    false    214            u           1259    24606    fki_FK    INDEX     D   CREATE INDEX "fki_FK" ON public."Lezione" USING btree ("ID_Corso");
    DROP INDEX public."fki_FK";
       public            postgres    false    211            r           1259    24582    fki_ID_Operatore    INDEX     U   CREATE INDEX "fki_ID_Operatore" ON public."Operatore " USING btree ("ID_Operatore");
 &   DROP INDEX public."fki_ID_Operatore";
       public            postgres    false    210            |           2606    24601 
   Lezione FK    FK CONSTRAINT     t   ALTER TABLE ONLY public."Lezione"
    ADD CONSTRAINT "FK" FOREIGN KEY ("ID_Corso") REFERENCES public."Corso"("ID");
 8   ALTER TABLE ONLY public."Lezione" DROP CONSTRAINT "FK";
       public          postgres    false    211    3185    209               �   x�U�=�0�g�> B�?b��: q SBd�$UZ8=E�R:~~z߳��[1��,/���S�c�;���/B�'���F$`��Њ5�HP��a��O�i��fiu����{���3��`#9G~���I���g��@q6#��u�L�YM]%��[O�#�Kӟ�WJ}�Z�      
   h   x���K
�0��ur��$i��\n�I��}PP��v�~�7*K�2W��PQ�8$=֘��B��__�����)>���p}�i?Zдo%뭻ݸ�60���28      	      x������ � �         t   x�3�v�I,�,.N����/JO�+.I-����ˈ�:$#?7���H�I�D��$e9N9���%��:M�:��Aʝ�sJ�dL9��Js2�p�4�L��ɽ(��=... 5F<�         ^   x��v��453��N���)�I�)�)�ɬ�4202�5��50����4426���IŐ1162�. �.�IC����073�]��	�)(�1z\\\ 8��         N   x�3444�4�I-.1��V1R2KK��sJK�2��R��r�V@T�ih airV���Mk�b���� ��r     