--
-- PostgreSQL database dump
--

\restrict Gud80BtITuRlWI2DroWNze3kQcY7Nn4rWIcCLrK2kb4rJFQkau0FNhmNO02SGe0

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-14 23:27:01

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

--
-- TOC entry 6 (class 2615 OID 16389)
-- Name: test; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: Accounts; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test."Accounts" (
    id bigint CONSTRAINT accounts_id_not_null NOT NULL,
    user_name text CONSTRAINT accounts_user_name_not_null NOT NULL,
    balance numeric(10,2)
);


ALTER TABLE test."Accounts" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: Transactions; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test."Transactions" (
    id bigint CONSTRAINT transactions_id_not_null NOT NULL,
    from_account_id bigint CONSTRAINT transactions_from_account_id_not_null NOT NULL,
    to_account_id bigint CONSTRAINT transactions_to_account_id_not_null NOT NULL,
    amount numeric(10,2) CONSTRAINT transactions_amount_not_null NOT NULL,
    "timestamp" timestamp without time zone CONSTRAINT transactions_timestamp_not_null NOT NULL,
    idempotency_key text
);


ALTER TABLE test."Transactions" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16414)
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

ALTER TABLE test."Accounts" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME test.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16415)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

ALTER TABLE test."Transactions" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME test.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5015 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: Accounts; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY test."Accounts" (id, user_name, balance) FROM stdin;
3	Igor	280.00
1	Ruslan	212.17
2	Ion	28.08
\.


--
-- TOC entry 5016 (class 0 OID 16399)
-- Dependencies: 221
-- Data for Name: Transactions; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY test."Transactions" (id, from_account_id, to_account_id, amount, "timestamp", idempotency_key) FROM stdin;
1	1	2	10.01	2025-11-15 10:00:00	\N
2	2	1	1.00	2025-11-15 10:00:00	\N
3	2	1	200.00	2025-11-11 22:38:08.417255	\N
4	1	11	0.00	2025-11-12 12:04:17.174318	\N
5	2	1	10.00	2025-11-12 13:22:21.298132	\N
6	2	1	0.02	2025-11-12 13:23:15.815419	\N
7	1	2	30.00	2025-11-12 13:53:45.010096	\N
8	2	1	100.43	2025-11-12 14:57:51.684662	\N
9	2	1	10.43	2025-11-12 14:58:44.785133	\N
10	1	2	10.20	2025-11-12 15:00:53.794688	\N
11	1	2	10.20	2025-11-12 15:21:45.619627	\N
12	1	2	10.20	2025-11-12 15:21:45.799613	\N
13	1	2	10.20	2025-11-12 15:21:46.482476	\N
14	1	2	70.02	2025-11-12 15:23:42.483871	\N
15	2	1	70.02	2025-11-12 15:26:38.667686	\N
16	2	1	70.02	2025-11-12 15:26:38.824231	\N
17	2	1	70.02	2025-11-12 15:26:38.99049	\N
18	2	1	1.00	2025-11-12 16:22:46.836737	string
19	2	1	1.00	2025-11-12 16:29:17.755341	sstring
20	1	2	10.00	2025-11-14 11:09:51.689656	string2
21	1	2	20.00	2025-11-14 11:12:28.522658	stringw
22	2	1	10.00	2025-11-14 11:12:29.173042	strings2
23	2	1	10.00	2025-11-14 11:27:22.072655	string2-1
24	3	1	20.00	2025-11-14 11:27:22.186892	string3-1
25	1	2	10.00	2025-11-14 12:01:50.518218	test1
\.


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 222
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('test.accounts_id_seq', 3, true);


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 223
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('test.transactions_id_seq', 25, true);


--
-- TOC entry 4865 (class 2606 OID 16423)
-- Name: Transactions Transactions_idempotency_key_key; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test."Transactions"
    ADD CONSTRAINT "Transactions_idempotency_key_key" UNIQUE (idempotency_key);


--
-- TOC entry 4863 (class 2606 OID 16398)
-- Name: Accounts accounts_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test."Accounts"
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 16408)
-- Name: Transactions transactions_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test."Transactions"
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


-- Completed on 2025-11-14 23:27:01

--
-- PostgreSQL database dump complete
--

\unrestrict Gud80BtITuRlWI2DroWNze3kQcY7Nn4rWIcCLrK2kb4rJFQkau0FNhmNO02SGe0

