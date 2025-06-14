toc.dat                                                                                             0000600 0004000 0002000 00000036723 15011142436 0014447 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP                       }            LMS    17.4    17.4 7    a           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false         b           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false         c           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false         d           1262    41429    LMS    DATABASE     k   CREATE DATABASE "LMS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';
    DROP DATABASE "LMS";
                     postgres    false         �            1259    65935    admin    TABLE     �   CREATE TABLE public.admin (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL
);
    DROP TABLE public.admin;
       public         heap r       postgres    false         �            1259    65934    admin_id_seq    SEQUENCE     �   CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.admin_id_seq;
       public               postgres    false    228         e           0    0    admin_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;
          public               postgres    false    227         �            1259    57811 	   book_logs    TABLE       CREATE TABLE public.book_logs (
    id integer NOT NULL,
    book_id integer,
    action_type character varying(50) NOT NULL,
    action_details jsonb NOT NULL,
    performed_by integer,
    performed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.book_logs;
       public         heap r       postgres    false         �            1259    57810    book_logs_id_seq    SEQUENCE     �   CREATE SEQUENCE public.book_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.book_logs_id_seq;
       public               postgres    false    226         f           0    0    book_logs_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.book_logs_id_seq OWNED BY public.book_logs.id;
          public               postgres    false    225         �            1259    57744    books    TABLE     �   CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    genre character varying(255) NOT NULL,
    quantity integer NOT NULL
);
    DROP TABLE public.books;
       public         heap r       postgres    false         �            1259    57743    books_id_seq    SEQUENCE     �   CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.books_id_seq;
       public               postgres    false    220         g           0    0    books_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;
          public               postgres    false    219         �            1259    57764    issued_books    TABLE     �   CREATE TABLE public.issued_books (
    id integer NOT NULL,
    user_id integer,
    book_id integer,
    issue_date date DEFAULT CURRENT_DATE,
    due_date date,
    return_date date,
    fine numeric DEFAULT 0,
    returned boolean DEFAULT false
);
     DROP TABLE public.issued_books;
       public         heap r       postgres    false         �            1259    57763    issued_books_id_seq    SEQUENCE     �   CREATE SEQUENCE public.issued_books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.issued_books_id_seq;
       public               postgres    false    224         h           0    0    issued_books_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.issued_books_id_seq OWNED BY public.issued_books.id;
          public               postgres    false    223         �            1259    57753 
   librarians    TABLE     �   CREATE TABLE public.librarians (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    salary numeric
);
    DROP TABLE public.librarians;
       public         heap r       postgres    false         �            1259    57752    librarians_id_seq    SEQUENCE     �   CREATE SEQUENCE public.librarians_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.librarians_id_seq;
       public               postgres    false    222         i           0    0    librarians_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.librarians_id_seq OWNED BY public.librarians.id;
          public               postgres    false    221         �            1259    57734    users    TABLE        CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.users;
       public         heap r       postgres    false         �            1259    57733    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    218         j           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    217         �           2604    65938    admin id    DEFAULT     d   ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);
 7   ALTER TABLE public.admin ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    228    228         �           2604    57814    book_logs id    DEFAULT     l   ALTER TABLE ONLY public.book_logs ALTER COLUMN id SET DEFAULT nextval('public.book_logs_id_seq'::regclass);
 ;   ALTER TABLE public.book_logs ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    225    226         �           2604    57747    books id    DEFAULT     d   ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);
 7   ALTER TABLE public.books ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    219    220    220         �           2604    57767    issued_books id    DEFAULT     r   ALTER TABLE ONLY public.issued_books ALTER COLUMN id SET DEFAULT nextval('public.issued_books_id_seq'::regclass);
 >   ALTER TABLE public.issued_books ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    224    224         �           2604    57756    librarians id    DEFAULT     n   ALTER TABLE ONLY public.librarians ALTER COLUMN id SET DEFAULT nextval('public.librarians_id_seq'::regclass);
 <   ALTER TABLE public.librarians ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    221    222    222         �           2604    57737    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    217    218    218         ^          0    65935    admin 
   TABLE DATA           :   COPY public.admin (id, name, email, password) FROM stdin;
    public               postgres    false    228       4958.dat \          0    57811 	   book_logs 
   TABLE DATA           i   COPY public.book_logs (id, book_id, action_type, action_details, performed_by, performed_at) FROM stdin;
    public               postgres    false    226       4956.dat V          0    57744    books 
   TABLE DATA           C   COPY public.books (id, title, author, genre, quantity) FROM stdin;
    public               postgres    false    220       4950.dat Z          0    57764    issued_books 
   TABLE DATA           o   COPY public.issued_books (id, user_id, book_id, issue_date, due_date, return_date, fine, returned) FROM stdin;
    public               postgres    false    224       4954.dat X          0    57753 
   librarians 
   TABLE DATA           =   COPY public.librarians (id, name, email, salary) FROM stdin;
    public               postgres    false    222       4952.dat T          0    57734    users 
   TABLE DATA           F   COPY public.users (id, name, email, password, created_at) FROM stdin;
    public               postgres    false    218       4948.dat k           0    0    admin_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.admin_id_seq', 3, true);
          public               postgres    false    227         l           0    0    book_logs_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.book_logs_id_seq', 1, true);
          public               postgres    false    225         m           0    0    books_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.books_id_seq', 104, true);
          public               postgres    false    219         n           0    0    issued_books_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.issued_books_id_seq', 4, true);
          public               postgres    false    223         o           0    0    librarians_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.librarians_id_seq', 1, true);
          public               postgres    false    221         p           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 1, true);
          public               postgres    false    217         �           2606    65942    admin admin_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.admin DROP CONSTRAINT admin_email_key;
       public                 postgres    false    228         �           2606    65940    admin admin_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.admin DROP CONSTRAINT admin_pkey;
       public                 postgres    false    228         �           2606    57819    book_logs book_logs_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.book_logs
    ADD CONSTRAINT book_logs_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.book_logs DROP CONSTRAINT book_logs_pkey;
       public                 postgres    false    226         �           2606    57751    books books_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.books DROP CONSTRAINT books_pkey;
       public                 postgres    false    220         �           2606    57774    issued_books issued_books_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issued_books_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.issued_books DROP CONSTRAINT issued_books_pkey;
       public                 postgres    false    224         �           2606    57762    librarians librarians_email_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.librarians
    ADD CONSTRAINT librarians_email_key UNIQUE (email);
 I   ALTER TABLE ONLY public.librarians DROP CONSTRAINT librarians_email_key;
       public                 postgres    false    222         �           2606    57760    librarians librarians_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.librarians
    ADD CONSTRAINT librarians_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.librarians DROP CONSTRAINT librarians_pkey;
       public                 postgres    false    222         �           2606    57742    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public                 postgres    false    218         �           2606    57740    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    218         �           1259    57830    idx_book_logs_action_type    INDEX     V   CREATE INDEX idx_book_logs_action_type ON public.book_logs USING btree (action_type);
 -   DROP INDEX public.idx_book_logs_action_type;
       public                 postgres    false    226         �           1259    57831    idx_book_logs_performed_at    INDEX     X   CREATE INDEX idx_book_logs_performed_at ON public.book_logs USING btree (performed_at);
 .   DROP INDEX public.idx_book_logs_performed_at;
       public                 postgres    false    226         �           2606    57820     book_logs book_logs_book_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.book_logs
    ADD CONSTRAINT book_logs_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id) ON DELETE SET NULL;
 J   ALTER TABLE ONLY public.book_logs DROP CONSTRAINT book_logs_book_id_fkey;
       public               postgres    false    226    220    4783         �           2606    57825 %   book_logs book_logs_performed_by_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.book_logs
    ADD CONSTRAINT book_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);
 O   ALTER TABLE ONLY public.book_logs DROP CONSTRAINT book_logs_performed_by_fkey;
       public               postgres    false    218    226    4781         �           2606    57780 &   issued_books issued_books_book_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issued_books_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);
 P   ALTER TABLE ONLY public.issued_books DROP CONSTRAINT issued_books_book_id_fkey;
       public               postgres    false    4783    224    220         �           2606    57775 &   issued_books issued_books_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issued_books_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 P   ALTER TABLE ONLY public.issued_books DROP CONSTRAINT issued_books_user_id_fkey;
       public               postgres    false    224    4781    218                                                     4958.dat                                                                                            0000600 0004000 0002000 00000000131 15011142436 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Umer	umer@email.com	123
2	Bilal	bilal@email.com	123
3	Shumaz	shumaz@email.com	123
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                       4956.dat                                                                                            0000600 0004000 0002000 00000000231 15011142436 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	\N	DELETE	{"genre": "Fiction", "title": "HARRY POTTER THE PHOENIX CHAMBER", "author": "JK ROWLING", "quantity": 204}	1	2025-05-13 00:32:54.476333
\.


                                                                                                                                                                                                                                                                                                                                                                       4950.dat                                                                                            0000600 0004000 0002000 00000011766 15011142436 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        3	Alchemist	Paulo Coelho	Fiction	10
5	Pride and Prejudice	Jane Austen	Classic Literature	15
6	To Kill a Mockingbird	Harper Lee	Classic Literature	20
7	1984	George Orwell	Classic Literature	25
8	The Great Gatsby	F. Scott Fitzgerald	Classic Literature	18
9	Lord of the Flies	William Golding	Classic Literature	12
10	The Catcher in the Rye	J.D. Salinger	Classic Literature	15
11	Brave New World	Aldous Huxley	Classic Literature	20
12	Animal Farm	George Orwell	Classic Literature	22
13	The Grapes of Wrath	John Steinbeck	Classic Literature	10
14	One Hundred Years of Solitude	Gabriel García Márquez	Classic Literature	15
15	The Alchemist	Paulo Coelho	Modern Fiction	25
16	The Kite Runner	Khaled Hosseini	Modern Fiction	20
17	Life of Pi	Yann Martel	Modern Fiction	15
18	The Da Vinci Code	Dan Brown	Modern Fiction	30
19	The Girl with the Dragon Tattoo	Stieg Larsson	Modern Fiction	18
20	Gone Girl	Gillian Flynn	Modern Fiction	20
21	The Help	Kathryn Stockett	Modern Fiction	15
22	The Book Thief	Markus Zusak	Modern Fiction	22
23	The Hunger Games	Suzanne Collins	Modern Fiction	35
24	Divergent	Veronica Roth	Modern Fiction	25
25	Dune	Frank Herbert	Science Fiction	30
26	Foundation	Isaac Asimov	Science Fiction	20
27	Neuromancer	William Gibson	Science Fiction	15
28	The Hobbit	J.R.R. Tolkien	Fantasy	40
29	The Name of the Wind	Patrick Rothfuss	Fantasy	18
30	Ender's Game	Orson Scott Card	Science Fiction	25
31	The Way of Kings	Brandon Sanderson	Fantasy	20
32	American Gods	Neil Gaiman	Fantasy	15
33	The Martian	Andy Weir	Science Fiction	28
34	Ready Player One	Ernest Cline	Science Fiction	22
35	The Girl on the Train	Paula Hawkins	Thriller	25
36	And Then There Were None	Agatha Christie	Mystery	20
37	The Silent Patient	Alex Michaelides	Thriller	18
38	The Thursday Murder Club	Richard Osman	Mystery	15
39	The Seven Husbands of Evelyn Hugo	Taylor Jenkins Reid	Mystery	20
40	Where the Crawdads Sing	Delia Owens	Mystery	28
41	The Guest List	Lucy Foley	Mystery	15
42	The Woman in the Window	A.J. Finn	Thriller	18
43	Big Little Lies	Liane Moriarty	Mystery	20
44	The Secret History	Donna Tartt	Mystery	15
45	A Brief History of Time	Stephen Hawking	Science	25
46	Sapiens	Yuval Noah Harari	Science	30
47	The Selfish Gene	Richard Dawkins	Science	15
48	Cosmos	Carl Sagan	Science	20
49	The Origin of Species	Charles Darwin	Science	18
50	Silent Spring	Rachel Carson	Science	15
51	The Double Helix	James D. Watson	Science	12
52	The Elegant Universe	Brian Greene	Science	15
53	The Immortal Life of Henrietta Lacks	Rebecca Skloot	Science	20
54	The Man Who Mistook His Wife for a Hat	Oliver Sacks	Science	15
55	Think and Grow Rich	Napoleon Hill	Business	25
56	Rich Dad Poor Dad	Robert Kiyosaki	Business	30
57	The Lean Startup	Eric Ries	Business	20
58	Zero to One	Peter Thiel	Business	18
59	Good to Great	Jim Collins	Business	15
60	The 7 Habits of Highly Effective People	Stephen Covey	Self-Help	25
61	Start with Why	Simon Sinek	Business	20
62	Thinking, Fast and Slow	Daniel Kahneman	Psychology	18
63	The Power of Habit	Charles Duhigg	Psychology	22
64	Freakonomics	Steven D. Levitt	Economics	15
65	The Subtle Art of Not Giving a F*ck	Mark Manson	Self-Help	35
66	Atomic Habits	James Clear	Self-Help	40
67	12 Rules for Life	Jordan B. Peterson	Psychology	25
68	The Four Agreements	Don Miguel Ruiz	Self-Help	20
69	Man's Search for Meaning	Viktor E. Frankl	Psychology	25
70	Quiet	Susan Cain	Psychology	18
71	Daring Greatly	Brené Brown	Self-Help	20
72	The Road Less Traveled	M. Scott Peck	Psychology	15
73	Flow	Mihaly Csikszentmihalyi	Psychology	12
74	Mindset	Carol S. Dweck	Psychology	20
75	Clean Code	Robert C. Martin	Programming	25
76	Design Patterns	Erich Gamma	Programming	20
77	The Pragmatic Programmer	Andrew Hunt	Programming	18
78	Introduction to Algorithms	Thomas H. Cormen	Programming	15
79	Code Complete	Steve McConnell	Programming	12
80	Refactoring	Martin Fowler	Programming	15
81	The Clean Coder	Robert C. Martin	Programming	20
82	Head First Design Patterns	Eric Freeman	Programming	18
83	JavaScript: The Good Parts	Douglas Crockford	Programming	22
84	Python Crash Course	Eric Matthes	Programming	30
85	Steve Jobs	Walter Isaacson	Biography	25
86	Becoming	Michelle Obama	Biography	30
87	The Diary of a Young Girl	Anne Frank	Biography	35
88	Long Walk to Freedom	Nelson Mandela	Biography	20
89	Educated	Tara Westover	Memoir	25
90	Born a Crime	Trevor Noah	Memoir	22
91	The Glass Castle	Jeannette Walls	Memoir	18
92	Unbroken	Laura Hillenbrand	Biography	15
93	Wild	Cheryl Strayed	Memoir	20
94	Kitchen Confidential	Anthony Bourdain	Memoir	18
95	Normal People	Sally Rooney	Contemporary Fiction	25
96	The Midnight Library	Matt Haig	Contemporary Fiction	30
97	Anxious People	Fredrik Backman	Contemporary Fiction	20
98	The Vanishing Half	Brit Bennett	Contemporary Fiction	18
99	Such a Fun Age	Kiley Reid	Contemporary Fiction	15
100	A Gentleman in Moscow	Amor Towles	Contemporary Fiction	22
101	Little Fires Everywhere	Celeste Ng	Contemporary Fiction	25
102	The Dutch House	Ann Patchett	Contemporary Fiction	18
103	Hamnet	Maggie O'Farrell	Historical Fiction	15
104	On Earth We're Briefly Gorgeous	Ocean Vuong	Contemporary Fiction	20
\.


          4954.dat                                                                                            0000600 0004000 0002000 00000000005 15011142436 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4952.dat                                                                                            0000600 0004000 0002000 00000000043 15011142436 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Babar	babar@email.com	12000
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             4948.dat                                                                                            0000600 0004000 0002000 00000000335 15011142436 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	ALEEZA	aleeza@email.com	scrypt:32768:8:1$31fKhNtAZ4Vqqzl6$7db07b7bbb030f8ab7c09db24f8523696e2572f867f25be40c1fa043678f17837fca44ab652c4c066dca419de9047b70a465556fbb05f8d7c63d8233ed87e8cf	2025-05-12 22:55:49.247687
\.


                                                                                                                                                                                                                                                                                                   restore.sql                                                                                         0000600 0004000 0002000 00000030271 15011142436 0015364 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "LMS";
--
-- Name: LMS; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "LMS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';


ALTER DATABASE "LMS" OWNER TO postgres;

\connect "LMS"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: book_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_logs (
    id integer NOT NULL,
    book_id integer,
    action_type character varying(50) NOT NULL,
    action_details jsonb NOT NULL,
    performed_by integer,
    performed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.book_logs OWNER TO postgres;

--
-- Name: book_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.book_logs_id_seq OWNER TO postgres;

--
-- Name: book_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_logs_id_seq OWNED BY public.book_logs.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    genre character varying(255) NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: issued_books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issued_books (
    id integer NOT NULL,
    user_id integer,
    book_id integer,
    issue_date date DEFAULT CURRENT_DATE,
    due_date date,
    return_date date,
    fine numeric DEFAULT 0,
    returned boolean DEFAULT false
);


ALTER TABLE public.issued_books OWNER TO postgres;

--
-- Name: issued_books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issued_books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.issued_books_id_seq OWNER TO postgres;

--
-- Name: issued_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issued_books_id_seq OWNED BY public.issued_books.id;


--
-- Name: librarians; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.librarians (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    salary numeric
);


ALTER TABLE public.librarians OWNER TO postgres;

--
-- Name: librarians_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.librarians_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.librarians_id_seq OWNER TO postgres;

--
-- Name: librarians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.librarians_id_seq OWNED BY public.librarians.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: book_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_logs ALTER COLUMN id SET DEFAULT nextval('public.book_logs_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: issued_books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books ALTER COLUMN id SET DEFAULT nextval('public.issued_books_id_seq'::regclass);


--
-- Name: librarians id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.librarians ALTER COLUMN id SET DEFAULT nextval('public.librarians_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, name, email, password) FROM stdin;
\.
COPY public.admin (id, name, email, password) FROM '$$PATH$$/4958.dat';

--
-- Data for Name: book_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_logs (id, book_id, action_type, action_details, performed_by, performed_at) FROM stdin;
\.
COPY public.book_logs (id, book_id, action_type, action_details, performed_by, performed_at) FROM '$$PATH$$/4956.dat';

--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id, title, author, genre, quantity) FROM stdin;
\.
COPY public.books (id, title, author, genre, quantity) FROM '$$PATH$$/4950.dat';

--
-- Data for Name: issued_books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issued_books (id, user_id, book_id, issue_date, due_date, return_date, fine, returned) FROM stdin;
\.
COPY public.issued_books (id, user_id, book_id, issue_date, due_date, return_date, fine, returned) FROM '$$PATH$$/4954.dat';

--
-- Data for Name: librarians; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.librarians (id, name, email, salary) FROM stdin;
\.
COPY public.librarians (id, name, email, salary) FROM '$$PATH$$/4952.dat';

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, created_at) FROM stdin;
\.
COPY public.users (id, name, email, password, created_at) FROM '$$PATH$$/4948.dat';

--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 3, true);


--
-- Name: book_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_logs_id_seq', 1, true);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 104, true);


--
-- Name: issued_books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issued_books_id_seq', 4, true);


--
-- Name: librarians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.librarians_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: admin admin_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: book_logs book_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_logs
    ADD CONSTRAINT book_logs_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: issued_books issued_books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issued_books_pkey PRIMARY KEY (id);


--
-- Name: librarians librarians_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.librarians
    ADD CONSTRAINT librarians_email_key UNIQUE (email);


--
-- Name: librarians librarians_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.librarians
    ADD CONSTRAINT librarians_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_book_logs_action_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_book_logs_action_type ON public.book_logs USING btree (action_type);


--
-- Name: idx_book_logs_performed_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_book_logs_performed_at ON public.book_logs USING btree (performed_at);


--
-- Name: book_logs book_logs_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_logs
    ADD CONSTRAINT book_logs_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id) ON DELETE SET NULL;


--
-- Name: book_logs book_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_logs
    ADD CONSTRAINT book_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: issued_books issued_books_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issued_books_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: issued_books issued_books_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issued_books_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       