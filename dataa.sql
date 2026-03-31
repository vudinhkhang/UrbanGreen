--
-- PostgreSQL database dump
--

\restrict UTuVBayo9gaUOGjjcR5YdNTpW8nqBVXly9iDILIkMuaAx4abxpjquC5xVYzx4Lm

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-01 03:41:05

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
-- TOC entry 220 (class 1259 OID 17370)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17369)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_id_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 219
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 222 (class 1259 OID 17381)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17380)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 221
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 224 (class 1259 OID 17391)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id bigint NOT NULL,
    content_type_id bigint NOT NULL,
    codename text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17390)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_permission_id_seq OWNER TO postgres;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 226 (class 1259 OID 17404)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id bigint NOT NULL,
    password text NOT NULL,
    last_login timestamp without time zone,
    is_superuser boolean NOT NULL,
    username text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp without time zone NOT NULL,
    first_name text NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17423)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17422)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 227
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 225 (class 1259 OID 17403)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_id_seq OWNER TO postgres;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 230 (class 1259 OID 17433)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17432)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 232 (class 1259 OID 17443)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id bigint NOT NULL,
    object_id text,
    object_repr text NOT NULL,
    action_flag bigint NOT NULL,
    change_message text NOT NULL,
    content_type_id bigint,
    user_id bigint NOT NULL,
    action_time timestamp without time zone NOT NULL
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17442)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_admin_log_id_seq OWNER TO postgres;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 231
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 234 (class 1259 OID 17458)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id bigint NOT NULL,
    app_label text NOT NULL,
    model text NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17457)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_content_type_id_seq OWNER TO postgres;

--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 233
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 236 (class 1259 OID 17470)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app text NOT NULL,
    name text NOT NULL,
    applied timestamp without time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17469)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 235
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 237 (class 1259 OID 17482)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key text NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp without time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17493)
-- Name: public_map_activitylog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_map_activitylog (
    id bigint NOT NULL,
    action_type text NOT NULL,
    entity_type text NOT NULL,
    entity_code text NOT NULL,
    detail text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    user_id bigint
);


ALTER TABLE public.public_map_activitylog OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17492)
-- Name: public_map_activitylog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_map_activitylog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.public_map_activitylog_id_seq OWNER TO postgres;

--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 238
-- Name: public_map_activitylog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_map_activitylog_id_seq OWNED BY public.public_map_activitylog.id;


--
-- TOC entry 241 (class 1259 OID 17508)
-- Name: public_map_maintenancelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_map_maintenancelog (
    id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    action text NOT NULL,
    performer text NOT NULL,
    note text NOT NULL,
    tree_id bigint NOT NULL
);


ALTER TABLE public.public_map_maintenancelog OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17507)
-- Name: public_map_maintenancelog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_map_maintenancelog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.public_map_maintenancelog_id_seq OWNER TO postgres;

--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 240
-- Name: public_map_maintenancelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_map_maintenancelog_id_seq OWNED BY public.public_map_maintenancelog.id;


--
-- TOC entry 243 (class 1259 OID 17523)
-- Name: public_map_managementzone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_map_managementzone (
    id bigint NOT NULL,
    name text NOT NULL,
    color text NOT NULL,
    polygon_json text NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.public_map_managementzone OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17522)
-- Name: public_map_managementzone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_map_managementzone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.public_map_managementzone_id_seq OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 242
-- Name: public_map_managementzone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_map_managementzone_id_seq OWNED BY public.public_map_managementzone.id;


--
-- TOC entry 245 (class 1259 OID 17537)
-- Name: public_map_treespecies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_map_treespecies (
    id bigint NOT NULL,
    name text NOT NULL,
    characteristics text NOT NULL,
    inspection_frequency_days bigint NOT NULL,
    is_pest_prone boolean NOT NULL,
    watering_frequency_days bigint NOT NULL,
    is_drought_sensitive boolean NOT NULL,
    is_fall_prone boolean NOT NULL,
    is_fast_growing boolean NOT NULL,
    is_invasive_roots boolean NOT NULL
);


ALTER TABLE public.public_map_treespecies OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17536)
-- Name: public_map_treespecies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_map_treespecies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.public_map_treespecies_id_seq OWNER TO postgres;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 244
-- Name: public_map_treespecies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_map_treespecies_id_seq OWNED BY public.public_map_treespecies.id;


--
-- TOC entry 247 (class 1259 OID 17556)
-- Name: public_map_urbantree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_map_urbantree (
    id bigint NOT NULL,
    code text NOT NULL,
    height double precision NOT NULL,
    status text NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    address text NOT NULL,
    species_id bigint NOT NULL,
    image text,
    district text,
    sub_district text
);


ALTER TABLE public.public_map_urbantree OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 17555)
-- Name: public_map_urbantree_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_map_urbantree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.public_map_urbantree_id_seq OWNER TO postgres;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 246
-- Name: public_map_urbantree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.public_map_urbantree_id_seq OWNED BY public.public_map_urbantree.id;


--
-- TOC entry 4927 (class 2604 OID 17373)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 4928 (class 2604 OID 17384)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 4929 (class 2604 OID 17394)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 4930 (class 2604 OID 17407)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 17426)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 4932 (class 2604 OID 17436)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 4933 (class 2604 OID 17446)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 4934 (class 2604 OID 17461)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 4935 (class 2604 OID 17473)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 4936 (class 2604 OID 17496)
-- Name: public_map_activitylog id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_activitylog ALTER COLUMN id SET DEFAULT nextval('public.public_map_activitylog_id_seq'::regclass);


--
-- TOC entry 4937 (class 2604 OID 17511)
-- Name: public_map_maintenancelog id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_maintenancelog ALTER COLUMN id SET DEFAULT nextval('public.public_map_maintenancelog_id_seq'::regclass);


--
-- TOC entry 4938 (class 2604 OID 17526)
-- Name: public_map_managementzone id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_managementzone ALTER COLUMN id SET DEFAULT nextval('public.public_map_managementzone_id_seq'::regclass);


--
-- TOC entry 4939 (class 2604 OID 17540)
-- Name: public_map_treespecies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_treespecies ALTER COLUMN id SET DEFAULT nextval('public.public_map_treespecies_id_seq'::regclass);


--
-- TOC entry 4940 (class 2604 OID 17559)
-- Name: public_map_urbantree id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_urbantree ALTER COLUMN id SET DEFAULT nextval('public.public_map_urbantree_id_seq'::regclass);


--
-- TOC entry 5131 (class 0 OID 17370)
-- Dependencies: 220
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 5133 (class 0 OID 17381)
-- Dependencies: 222
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5135 (class 0 OID 17391)
-- Dependencies: 224
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, content_type_id, codename, name) FROM stdin;
1	1	add_logentry	Can add log entry
2	1	change_logentry	Can change log entry
3	1	delete_logentry	Can delete log entry
4	1	view_logentry	Can view log entry
5	3	add_permission	Can add permission
6	3	change_permission	Can change permission
7	3	delete_permission	Can delete permission
8	3	view_permission	Can view permission
9	2	add_group	Can add group
10	2	change_group	Can change group
11	2	delete_group	Can delete group
12	2	view_group	Can view group
13	4	add_user	Can add user
14	4	change_user	Can change user
15	4	delete_user	Can delete user
16	4	view_user	Can view user
17	5	add_contenttype	Can add content type
18	5	change_contenttype	Can change content type
19	5	delete_contenttype	Can delete content type
20	5	view_contenttype	Can view content type
21	6	add_session	Can add session
22	6	change_session	Can change session
23	6	delete_session	Can delete session
24	6	view_session	Can view session
25	8	add_urbantree	Can add urban tree
26	8	change_urbantree	Can change urban tree
27	8	delete_urbantree	Can delete urban tree
28	8	view_urbantree	Can view urban tree
29	7	add_treespecies	Can add tree species
30	7	change_treespecies	Can change tree species
31	7	delete_treespecies	Can delete tree species
32	7	view_treespecies	Can view tree species
33	9	add_maintenancelog	Can add maintenance log
34	9	change_maintenancelog	Can change maintenance log
35	9	delete_maintenancelog	Can delete maintenance log
36	9	view_maintenancelog	Can view maintenance log
37	10	add_managementzone	Can add management zone
38	10	change_managementzone	Can change management zone
39	10	delete_managementzone	Can delete management zone
40	10	view_managementzone	Can view management zone
41	11	add_activitylog	Can add Nhật ký hoạt động
42	11	change_activitylog	Can change Nhật ký hoạt động
43	11	delete_activitylog	Can delete Nhật ký hoạt động
44	11	view_activitylog	Can view Nhật ký hoạt động
\.


--
-- TOC entry 5137 (class 0 OID 17404)
-- Dependencies: 226
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, last_name, email, is_staff, is_active, date_joined, first_name) FROM stdin;
3	pbkdf2_sha256$1200000$tRgdGjncXMfxnlb8gxfjN5$X2WUFJEozkZhew2qzWuB2XLWl5mmgWTMNj/unTalgi0=	2026-03-31 20:08:02.275156	f	demo_user	Nguyễn Quốc	1250080075@sv.hcmunre.edu.vn	f	t	2026-03-27 06:11:17.226865	Huy
2	pbkdf2_sha256$1200000$WMR1ykVuBgEtoO7kUXN2bp$oV39L1oIbg3pkkQGVBwXYp6c8QqDzG8ulW/UwTlZNRc=	2026-03-31 20:10:18.936204	t	admin	Vd	1250080081@sv.hcmunre.edu.vn	t	t	2026-02-06 04:55:50.190556	Khang
\.


--
-- TOC entry 5139 (class 0 OID 17423)
-- Dependencies: 228
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 5141 (class 0 OID 17433)
-- Dependencies: 230
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5143 (class 0 OID 17443)
-- Dependencies: 232
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, object_id, object_repr, action_flag, change_message, content_type_id, user_id, action_time) FROM stdin;
1	1	k	3		4	2	2026-02-06 04:56:58.929563
2	1	Phượng Vĩ	1	[{"added": {}}]	7	2	2026-02-06 05:02:20.919156
3	2	Xà Cừ	1	[{"added": {}}]	7	2	2026-02-06 05:02:32.875188
4	1	PV_001 - Phượng Vĩ	1	[{"added": {}}]	8	2	2026-02-06 05:05:05.960788
5	1	PV_001 - Phượng Vĩ	2	[{"changed": {"fields": ["H\\u00ecnh \\u1ea3nh"]}}]	8	2	2026-02-06 05:36:16.294071
6	2	XC_001 - Xà Cừ	1	[{"added": {}}]	8	2	2026-02-06 05:59:32.483018
7	2	XC_001 - Xà Cừ	2	[]	8	2	2026-02-06 06:21:56.552455
8	1	PV_001 - Phượng Vĩ	2	[]	8	2	2026-02-06 06:22:00.051588
9	3	BL_001 - Cây Bằng Lăng	1	[{"added": {}}]	8	2	2026-02-06 06:45:49.757765
\.


--
-- TOC entry 5145 (class 0 OID 17458)
-- Dependencies: 234
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	public_map	treespecies
8	public_map	urbantree
9	public_map	maintenancelog
10	public_map	managementzone
11	public_map	activitylog
\.


--
-- TOC entry 5147 (class 0 OID 17470)
-- Dependencies: 236
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-02-06 04:08:58.822974
2	auth	0001_initial	2026-02-06 04:08:58.858224
3	admin	0001_initial	2026-02-06 04:08:58.886391
4	admin	0002_logentry_remove_auto_add	2026-02-06 04:08:58.914528
5	admin	0003_logentry_add_action_flag_choices	2026-02-06 04:08:58.932801
6	contenttypes	0002_remove_content_type_name	2026-02-06 04:08:58.97998
7	auth	0002_alter_permission_name_max_length	2026-02-06 04:08:59.017163
8	auth	0003_alter_user_email_max_length	2026-02-06 04:08:59.057077
9	auth	0004_alter_user_username_opts	2026-02-06 04:08:59.08246
10	auth	0005_alter_user_last_login_null	2026-02-06 04:08:59.106057
11	auth	0006_require_contenttypes_0002	2026-02-06 04:08:59.113714
12	auth	0007_alter_validators_add_error_messages	2026-02-06 04:08:59.138365
13	auth	0008_alter_user_username_max_length	2026-02-06 04:08:59.161796
14	auth	0009_alter_user_last_name_max_length	2026-02-06 04:08:59.179153
15	auth	0010_alter_group_name_max_length	2026-02-06 04:08:59.209821
16	auth	0011_update_proxy_permissions	2026-02-06 04:08:59.231607
17	auth	0012_alter_user_first_name_max_length	2026-02-06 04:08:59.27399
18	sessions	0001_initial	2026-02-06 04:08:59.322711
19	public_map	0001_initial	2026-02-06 04:34:58.456744
20	public_map	0002_urbantree_image	2026-02-06 05:33:45.122164
21	public_map	0003_maintenancelog	2026-02-06 05:50:09.682724
22	public_map	0004_treespecies_inspection_frequency_days_and_more	2026-03-06 06:59:15.231136
23	public_map	0005_treespecies_is_drought_sensitive_and_more	2026-03-06 07:03:55.516775
24	public_map	0006_managementzone	2026-03-06 07:38:04.18951
25	public_map	0007_urbantree_district_and_subdistrict	2026-03-20 07:00:04.524716
26	public_map	0007_activitylog	2026-03-27 08:27:41.912462
\.


--
-- TOC entry 5148 (class 0 OID 17482)
-- Dependencies: 237
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
is0qztxerumej7lu2rv55p6mdy5wd2eg	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1voFa4:nA1yDXxiWrwn_FSXr1T53yH3ILxUwye6Y3jLxruDvnU	2026-02-20 06:44:40.56835
eqxrn5vr4m0tmcdmu49wbr1xki0j1wvk	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1vyQKR:KKj5ssQHEYItSS5QGUCw3cLosvb838a_6AHmKVvF_RM	2026-03-20 08:14:35.716551
kmj7ipn6bens9ok1t7n8bzekk8nv0gkz	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60nr:tf0AqRQs1ymP6tmnw1GB1jlXM0T5Dz7lmSficShtKlM	2026-04-10 06:36:19.334548
xef1v9b0kxu9jfieoeoe1xmlet65nzja	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60pO:N8aOPh4esCfPClTGkO2XeKIgbtu7-hk9vmT-KgE-Tsk	2026-04-10 06:37:54.736379
5h5ehqdtujvsj11ymqtirce7d1y94n2y	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60pm:iEMTVqNZrf_9GqENNiUY_saSwvJF30Yst68yxEZF_pw	2026-04-10 06:38:18.093284
bcqyorz8hgcy5gv8br7b630qiw4ph4oa	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60uz:gbCvCb7CaSO3GmYir3G5Rh3N30i5gWCgANxKz8FS32g	2026-04-10 06:43:41.458067
jzmrklg53zzdnmjfjt79g2fsr6qziy34	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w6154:DcG1aToxxKVhaeweComovZzjcQArCE2raD2MXlcMQs8	2026-04-10 06:54:06.162272
ktzclot8mx5zzi0pxvid6ek713idwjer	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w615e:bCVdvIH6-hPuxCbRJBTu18TR5ko_fzzl9_79-QVNhSY	2026-04-10 06:54:42.461037
ere573n69gytjta4l4bphi0xvxjssu3u	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61GW:i-E_Qov7d5BuZpBDWMYYO-UnPSEPySp6duLrU1JKpj4	2026-04-10 07:05:56.159152
4dxmcg50o4pekd9uohxi6v908e65d2to	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61LX:QuTYuFa2rFJrIvC774-8xVuOPJ8IhPHn7SmmfsI_Mkc	2026-04-10 07:11:07.893967
i9vxwld66m2hoxdoquolk96asgxxs6o1	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61Nq:lI0rdhl2Fxk4G8ON4kJ4KDDdFxawNVZpgYKHswNqK8Y	2026-04-10 07:13:30.122834
g9lvxlsw7r9p9gf2679pw63qggn0ugcg	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61Nz:2F5rfoZeg6BF6muAJTkwJpXW_YVGDTdmTcX66IwcrVk	2026-04-10 07:13:39.984746
go2z94fa0t606mdttpm89j2etf3al8xl	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61OY:Z0g4y9zBmyd__-6EDhMsivuVR7U4tiJl4Rlcmw6FbiE	2026-04-10 07:14:14.060266
mpj0vlfkjmp5ghfscs6rssf312mknkyp	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61V0:mWZCvZXBFMpv-iXOLNqf8yoHcf7dtGgEcxC254nZ7qw	2026-04-10 07:20:54.878493
4s7xtek964oa0m96cnddi0s854lyqypa	.eJxVjMsOwiAQAP9lz4bw6gI9evcbGpYFqRpI-jgZ_9006UGvM5N5wxT3rU77mpdpZhjBwOWXUUzP3A7Bj9juXaTetmUmcSTitKu4dc6v69n-DWpcK4xgnWSPypDTRErZMCSDJvtQbLIlsA42Fx0wMyZkCtopab2hAT2jZAOfL8guNy0:1w61bG:IADgVVwpfmKkgXOUEuJtgUSx3DCXWFb_prQx1dyG4NY	2026-04-10 07:27:22.308717
bxy1xma09f2ev9c8lgtvkwgwggjaftfi	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w62gl:lw6-GsjxHJFd7f5632gmvFgJwTwG6lxagJIy4FbE1nc	2026-04-10 08:37:07.905021
k63sj8drf1tnr52uynannavi9x8b3mc8	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w7fPm:Cy_zeHJzBuS_D5KNG7choEHsHWIyujeBL6oF00KsDyk	2026-04-14 20:10:18.937716
\.


--
-- TOC entry 5150 (class 0 OID 17493)
-- Dependencies: 239
-- Data for Name: public_map_activitylog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_map_activitylog (id, action_type, entity_type, entity_code, detail, created_at, user_id) FROM stdin;
1	ADD_TREE	TREE	PV006	Thêm cây mới PV006 (Phượng Vĩ)	2026-03-31 17:21:02.503022	2
\.


--
-- TOC entry 5152 (class 0 OID 17508)
-- Dependencies: 241
-- Data for Name: public_map_maintenancelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_map_maintenancelog (id, date, action, performer, note, tree_id) FROM stdin;
1	2026-02-06 00:00:00	CAT_TIA	Khang	cắt toàn bộ cành	1
2	2026-02-05 00:00:00	KIEM_TRA	huy	test	1
3	2026-03-13 00:00:00	CAT_TIA	khang		1
4	2026-03-13 00:00:00	CAT_TIA	khang		3
\.


--
-- TOC entry 5154 (class 0 OID 17523)
-- Dependencies: 243
-- Data for Name: public_map_managementzone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_map_managementzone (id, name, color, polygon_json, created_at) FROM stdin;
\.


--
-- TOC entry 5156 (class 0 OID 17537)
-- Dependencies: 245
-- Data for Name: public_map_treespecies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_map_treespecies (id, name, characteristics, inspection_frequency_days, is_pest_prone, watering_frequency_days, is_drought_sensitive, is_fall_prone, is_fast_growing, is_invasive_roots) FROM stdin;
1	Phượng Vĩ	Rễ nông, cành giòn, dễ gãy đổ khi gặp gió bão. Cần cắt tỉa thường xuyên.	90	f	7	f	t	t	f
2	Xà Cừ	Rễ phát triển mạnh, dễ gây hư hại vỉa hè và công trình ngầm.	90	t	7	t	f	f	t
3	Cây Bằng Lăng	Hoa màu tím đẹp, tán lá rậm hình oval. Rễ cọc đâm sâu, ít phá hoại công trình ngầm	90	f	7	t	f	t	f
\.


--
-- TOC entry 5158 (class 0 OID 17556)
-- Dependencies: 247
-- Data for Name: public_map_urbantree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.public_map_urbantree (id, code, height, status, latitude, longitude, address, species_id, image, district, sub_district) FROM stdin;
1	PV_001	8.5	TOT	10.85294	106.62953	Cổng chính Công viên Phần mềm Quang Trung, Q.12, TP.HCM	1	tree_images/1588905423_2712_ac3c6ea58f7a18dd75a75725f4e5963a.jpg	\N	\N
2	XC_001	15.2	SAU_BENH	10.77443	106.69228	Góc đường Trương Định - Nguyễn Thị Minh Khai, Q.1.	2	tree_images/images.jpg	\N	\N
3	BL_001	4.5	TOT	10.85325	106.6297	Dọc lối đi bộ, tòa nhà QTSC 9, Q.12.	3	tree_images/pngtree-tree-clipart-green-vector-forest-material-cartoon-big-tree-png-image_5563922.jpg	\N	\N
4	PV001	5	TOT	10.79550091253234	106.70108556747438	Sân bay	1		\N	\N
5	PV002	5	TOT	10.811681989723436	106.63737773895265	Sân bay	1		\N	\N
6	PV003	4	TOT	10.811892757424635	106.63803219795228	Sân bay	1		\N	\N
7	PV004	4	TOT	10.812156216842931	106.6387188434601	Sân bay	1		\N	\N
8	PV005	6	TOT	10.81240913766682	106.63944840431215	Sân bay	1		\N	\N
9	PV006	5.6	TOT	10.812577751430954	106.63995265960693	Sân bay	1	tree_images/shopping.webp	\N	\N
\.


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 219
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 221
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 44, true);


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 227
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 3, true);


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 231
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 9, true);


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 233
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 11, true);


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 235
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 26, true);


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 238
-- Name: public_map_activitylog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_map_activitylog_id_seq', 1, true);


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 240
-- Name: public_map_maintenancelog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_map_maintenancelog_id_seq', 4, true);


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 242
-- Name: public_map_managementzone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_map_managementzone_id_seq', 1, false);


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 244
-- Name: public_map_treespecies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_map_treespecies_id_seq', 3, true);


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 246
-- Name: public_map_urbantree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_map_urbantree_id_seq', 9, true);


--
-- TOC entry 4944 (class 2606 OID 17389)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4942 (class 2606 OID 17379)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4946 (class 2606 OID 17402)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 17431)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4948 (class 2606 OID 17421)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 17441)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 17456)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4956 (class 2606 OID 17468)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 2606 OID 17481)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 2606 OID 17491)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 4962 (class 2606 OID 17506)
-- Name: public_map_activitylog public_map_activitylog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_activitylog
    ADD CONSTRAINT public_map_activitylog_pkey PRIMARY KEY (id);


--
-- TOC entry 4964 (class 2606 OID 17521)
-- Name: public_map_maintenancelog public_map_maintenancelog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_maintenancelog
    ADD CONSTRAINT public_map_maintenancelog_pkey PRIMARY KEY (id);


--
-- TOC entry 4966 (class 2606 OID 17535)
-- Name: public_map_managementzone public_map_managementzone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_managementzone
    ADD CONSTRAINT public_map_managementzone_pkey PRIMARY KEY (id);


--
-- TOC entry 4968 (class 2606 OID 17554)
-- Name: public_map_treespecies public_map_treespecies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_treespecies
    ADD CONSTRAINT public_map_treespecies_pkey PRIMARY KEY (id);


--
-- TOC entry 4970 (class 2606 OID 17571)
-- Name: public_map_urbantree public_map_urbantree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_urbantree
    ADD CONSTRAINT public_map_urbantree_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 17572)
-- Name: auth_group_permissions auth_group_permissions_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_fk_0 FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- TOC entry 4972 (class 2606 OID 17577)
-- Name: auth_group_permissions auth_group_permissions_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_fk_1 FOREIGN KEY (group_id) REFERENCES public.auth_group(id);


--
-- TOC entry 4973 (class 2606 OID 17582)
-- Name: auth_permission auth_permission_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_fk_0 FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id);


--
-- TOC entry 4974 (class 2606 OID 17587)
-- Name: auth_user_groups auth_user_groups_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_fk_0 FOREIGN KEY (group_id) REFERENCES public.auth_group(id);


--
-- TOC entry 4975 (class 2606 OID 17592)
-- Name: auth_user_groups auth_user_groups_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_fk_1 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 4976 (class 2606 OID 17597)
-- Name: auth_user_user_permissions auth_user_user_permissions_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_fk_0 FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- TOC entry 4977 (class 2606 OID 17602)
-- Name: auth_user_user_permissions auth_user_user_permissions_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_fk_1 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 4978 (class 2606 OID 17607)
-- Name: django_admin_log django_admin_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_fk_0 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 4979 (class 2606 OID 17612)
-- Name: django_admin_log django_admin_log_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_fk_1 FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id);


--
-- TOC entry 4980 (class 2606 OID 17617)
-- Name: public_map_activitylog public_map_activitylog_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_activitylog
    ADD CONSTRAINT public_map_activitylog_fk_0 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 4981 (class 2606 OID 17622)
-- Name: public_map_maintenancelog public_map_maintenancelog_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_maintenancelog
    ADD CONSTRAINT public_map_maintenancelog_fk_0 FOREIGN KEY (tree_id) REFERENCES public.public_map_urbantree(id);


--
-- TOC entry 4982 (class 2606 OID 17627)
-- Name: public_map_urbantree public_map_urbantree_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_map_urbantree
    ADD CONSTRAINT public_map_urbantree_fk_0 FOREIGN KEY (species_id) REFERENCES public.public_map_treespecies(id);


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO urbangreen_user;


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE auth_group; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_group TO urbangreen_user;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE auth_group_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_group_id_seq TO urbangreen_user;


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE auth_group_permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_group_permissions TO urbangreen_user;


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE auth_group_permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_group_permissions_id_seq TO urbangreen_user;


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE auth_permission; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_permission TO urbangreen_user;


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE auth_permission_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_permission_id_seq TO urbangreen_user;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE auth_user; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_user TO urbangreen_user;


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE auth_user_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_user_groups TO urbangreen_user;


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE auth_user_groups_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_user_groups_id_seq TO urbangreen_user;


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE auth_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_user_id_seq TO urbangreen_user;


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE auth_user_user_permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_user_user_permissions TO urbangreen_user;


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE auth_user_user_permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_user_user_permissions_id_seq TO urbangreen_user;


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE django_admin_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_admin_log TO urbangreen_user;


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE django_admin_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.django_admin_log_id_seq TO urbangreen_user;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE django_content_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_content_type TO urbangreen_user;


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE django_content_type_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.django_content_type_id_seq TO urbangreen_user;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE django_migrations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_migrations TO urbangreen_user;


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 235
-- Name: SEQUENCE django_migrations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.django_migrations_id_seq TO urbangreen_user;


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE django_session; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_session TO urbangreen_user;


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE public_map_activitylog; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_map_activitylog TO urbangreen_user;


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 238
-- Name: SEQUENCE public_map_activitylog_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.public_map_activitylog_id_seq TO urbangreen_user;


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE public_map_maintenancelog; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_map_maintenancelog TO urbangreen_user;


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE public_map_maintenancelog_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.public_map_maintenancelog_id_seq TO urbangreen_user;


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE public_map_managementzone; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_map_managementzone TO urbangreen_user;


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 242
-- Name: SEQUENCE public_map_managementzone_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.public_map_managementzone_id_seq TO urbangreen_user;


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE public_map_treespecies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_map_treespecies TO urbangreen_user;


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE public_map_treespecies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.public_map_treespecies_id_seq TO urbangreen_user;


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE public_map_urbantree; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_map_urbantree TO urbangreen_user;


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE public_map_urbantree_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.public_map_urbantree_id_seq TO urbangreen_user;


--
-- TOC entry 2122 (class 826 OID 17634)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO urbangreen_user;


--
-- TOC entry 2121 (class 826 OID 17633)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO urbangreen_user;


-- Completed on 2026-04-01 03:41:05

--
-- PostgreSQL database dump complete
--

\unrestrict UTuVBayo9gaUOGjjcR5YdNTpW8nqBVXly9iDILIkMuaAx4abxpjquC5xVYzx4Lm

