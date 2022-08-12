create schema if not exists "public";

create table "public"."iot_planner_categories" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "invoicerelevance" numeric(2,1),
    "bonusrelevance" numeric(2,1),
    "tenant" character varying(5000),
    "title" character varying(5000),
    "description" character varying(5000),
    "reference" character varying(5000),
    "mappingid" character varying(5000),
    "drilldownstate" character varying(5000) default 'expanded'::character varying,
    "path" character varying(5000),
    "hierarchylevel" character varying(5000),
    "levelspecificid" character varying(5000),
    "catnumber" character varying(5000),
    "manager_userprincipalname" character varying(5000),
    "parent_id" character varying(36)
);


create table "public"."iot_planner_categorylevels" (
    "tenant" character varying(5000),
    "hierarchylevel" character varying(5000) not null,
    "title" character varying(5000)
);


create table "public"."iot_planner_tags" (
    "tenant" character varying(5000),
    "title" character varying(5000) not null,
    "category_id" character varying(36),
    "workitem_id" character varying(5000)
);


create table "public"."iot_planner_tags2categories" (
    "id" character varying(36) not null,
    "tenant" character varying(5000),
    "tag_title" character varying(5000),
    "category_id" character varying(36)
);


create table "public"."iot_planner_tags2workitems" (
    "id" character varying(36) not null,
    "tenant" character varying(5000),
    "tag_title" character varying(5000),
    "workitem_id" character varying(5000)
);


create table "public"."iot_planner_travels" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "tenant" character varying(5000),
    "user_userprincipalname" character varying(5000),
    "parent_id" character varying(36)
);


create table "public"."iot_planner_users" (
    "tenant" character varying(5000),
    "userprincipalname" character varying(5000) not null,
    "displayname" character varying(5000),
    "givenname" character varying(5000),
    "jobtitle" character varying(5000),
    "mail" character varying(5000),
    "mobilephone" character varying(5000),
    "officelocation" character varying(5000),
    "preferredlanguage" character varying(5000),
    "surname" character varying(5000),
    "manager_userprincipalname" character varying(5000)
);


create table "public"."iot_planner_users2categories" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "tenant" character varying(5000),
    "user_userprincipalname" character varying(5000),
    "category_id" character varying(36)
);


create table "public"."iot_planner_workitems" (
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "invoicerelevance" numeric(2,1),
    "bonusrelevance" numeric(2,1),
    "tenant" character varying(5000),
    "id" character varying(5000) not null,
    "activateddate" timestamp with time zone,
    "activateddatemonth" integer,
    "activateddateyear" integer,
    "activateddateday" integer,
    "completeddate" timestamp with time zone,
    "completeddatemonth" integer,
    "completeddateyear" integer,
    "completeddateday" integer,
    "assignedto_userprincipalname" character varying(5000),
    "changeddate" timestamp with time zone,
    "assignedtoname" character varying(5000),
    "createddate" timestamp with time zone,
    "reason" character varying(5000),
    "state" character varying(5000),
    "teamproject" character varying(5000),
    "title" character varying(5000),
    "workitemtype" character varying(5000),
    "completedwork" numeric(2,0),
    "remainingwork" numeric(2,0),
    "originalestimate" numeric(2,0),
    "resolveddate" timestamp with time zone,
    "closeddate" timestamp with time zone,
    "private" boolean,
    "isallday" boolean,
    "type" character varying(5000),
    "duration" numeric(2,0) default 0,
    "resetentry" boolean,
    "deleted" boolean,
    "confirmed" boolean,
    "parent_id" character varying(36),
    "parentpath" character varying(5000)
);


create table "public"."msgraphservice_events" (
    "id" character varying(5000) not null,
    "subject" character varying(5000),
    "startdate" timestamp with time zone,
    "enddate" timestamp with time zone,
    "customer" character varying(5000),
    "private" boolean,
    "isallday" boolean
);


create table "public"."msgraphservice_users" (
    "id" character varying(36) not null,
    "displayname" character varying(5000),
    "givenname" character varying(5000),
    "jobtitle" character varying(5000),
    "mail" character varying(5000),
    "mobilephone" character varying(5000),
    "officelocation" character varying(5000),
    "preferredlanguage" character varying(5000),
    "surname" character varying(5000),
    "userprincipalname" character varying(5000)
);


CREATE UNIQUE INDEX iot_planner_categories_pkey ON public.iot_planner_categories USING btree (id);

CREATE UNIQUE INDEX iot_planner_categorylevels_pkey ON public.iot_planner_categorylevels USING btree (hierarchylevel);

CREATE UNIQUE INDEX iot_planner_tags2categories_pkey ON public.iot_planner_tags2categories USING btree (id);

CREATE UNIQUE INDEX iot_planner_tags2workitems_pkey ON public.iot_planner_tags2workitems USING btree (id);

CREATE UNIQUE INDEX iot_planner_tags_pkey ON public.iot_planner_tags USING btree (title);

CREATE UNIQUE INDEX iot_planner_travels_pkey ON public.iot_planner_travels USING btree (id);

CREATE UNIQUE INDEX iot_planner_users2categories_pkey ON public.iot_planner_users2categories USING btree (id);

CREATE UNIQUE INDEX iot_planner_users_friendlyid ON public.iot_planner_users USING btree (userprincipalname);

CREATE UNIQUE INDEX iot_planner_workitems_pkey ON public.iot_planner_workitems USING btree (id);

CREATE UNIQUE INDEX msgraphservice_events_pkey ON public.msgraphservice_events USING btree (id);

CREATE UNIQUE INDEX msgraphservice_users_pkey ON public.msgraphservice_users USING btree (id);

alter table "public"."iot_planner_categories" add constraint "iot_planner_categories_pkey" PRIMARY KEY using index "iot_planner_categories_pkey";

alter table "public"."iot_planner_categorylevels" add constraint "iot_planner_categorylevels_pkey" PRIMARY KEY using index "iot_planner_categorylevels_pkey";

alter table "public"."iot_planner_tags" add constraint "iot_planner_tags_pkey" PRIMARY KEY using index "iot_planner_tags_pkey";

alter table "public"."iot_planner_tags2categories" add constraint "iot_planner_tags2categories_pkey" PRIMARY KEY using index "iot_planner_tags2categories_pkey";

alter table "public"."iot_planner_tags2workitems" add constraint "iot_planner_tags2workitems_pkey" PRIMARY KEY using index "iot_planner_tags2workitems_pkey";

alter table "public"."iot_planner_travels" add constraint "iot_planner_travels_pkey" PRIMARY KEY using index "iot_planner_travels_pkey";

alter table "public"."iot_planner_users" add constraint "iot_planner_users_friendlyid" PRIMARY KEY using index "iot_planner_users_friendlyid";

alter table "public"."iot_planner_users2categories" add constraint "iot_planner_users2categories_pkey" PRIMARY KEY using index "iot_planner_users2categories_pkey";

alter table "public"."iot_planner_workitems" add constraint "iot_planner_workitems_pkey" PRIMARY KEY using index "iot_planner_workitems_pkey";

alter table "public"."msgraphservice_events" add constraint "msgraphservice_events_pkey" PRIMARY KEY using index "msgraphservice_events_pkey";

alter table "public"."msgraphservice_users" add constraint "msgraphservice_users_pkey" PRIMARY KEY using index "msgraphservice_users_pkey";

create or replace view "public"."adminservice_categories" as  SELECT categories_0.id,
    categories_0.createdat,
    categories_0.createdby,
    categories_0.modifiedat,
    categories_0.modifiedby,
    categories_0.invoicerelevance,
    categories_0.bonusrelevance,
    categories_0.tenant,
    categories_0.title,
    categories_0.description,
    categories_0.reference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.levelspecificid,
    categories_0.catnumber,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


create or replace view "public"."adminservice_tags" as  SELECT tags_0.tenant,
    tags_0.title,
    tags_0.category_id,
    tags_0.workitem_id
   FROM iot_planner_tags tags_0;


create or replace view "public"."adminservice_tags2categories" as  SELECT tags2categories_0.id,
    tags2categories_0.tenant,
    tags2categories_0.tag_title,
    tags2categories_0.category_id
   FROM iot_planner_tags2categories tags2categories_0;


create or replace view "public"."adminservice_tags2workitems" as  SELECT tags2workitems_0.id,
    tags2workitems_0.tenant,
    tags2workitems_0.tag_title,
    tags2workitems_0.workitem_id
   FROM iot_planner_tags2workitems tags2workitems_0;


create or replace view "public"."adminservice_travels" as  SELECT travels_0.id,
    travels_0.createdat,
    travels_0.createdby,
    travels_0.modifiedat,
    travels_0.modifiedby,
    travels_0.tenant,
    travels_0.user_userprincipalname,
    travels_0.parent_id
   FROM iot_planner_travels travels_0;


create or replace view "public"."adminservice_users" as  SELECT users_0.tenant,
    users_0.userprincipalname,
    users_0.displayname,
    users_0.givenname,
    users_0.jobtitle,
    users_0.mail,
    users_0.mobilephone,
    users_0.officelocation,
    users_0.preferredlanguage,
    users_0.surname,
    users_0.manager_userprincipalname
   FROM iot_planner_users users_0;


create or replace view "public"."adminservice_users2categories" as  SELECT users2categories_0.id,
    users2categories_0.createdat,
    users2categories_0.createdby,
    users2categories_0.modifiedat,
    users2categories_0.modifiedby,
    users2categories_0.tenant,
    users2categories_0.user_userprincipalname,
    users2categories_0.category_id,
    user_1.displayname
   FROM (iot_planner_users2categories users2categories_0
     LEFT JOIN iot_planner_users user_1 ON (((users2categories_0.user_userprincipalname)::text = (user_1.userprincipalname)::text)));


create or replace view "public"."adminservice_workitems" as  SELECT workitems_0.createdat,
    workitems_0.createdby,
    workitems_0.modifiedat,
    workitems_0.modifiedby,
    workitems_0.invoicerelevance,
    workitems_0.bonusrelevance,
    workitems_0.tenant,
    workitems_0.id,
    workitems_0.activateddate,
    workitems_0.activateddatemonth,
    workitems_0.activateddateyear,
    workitems_0.activateddateday,
    workitems_0.completeddate,
    workitems_0.completeddatemonth,
    workitems_0.completeddateyear,
    workitems_0.completeddateday,
    workitems_0.assignedto_userprincipalname,
    workitems_0.changeddate,
    workitems_0.assignedtoname,
    workitems_0.createddate,
    workitems_0.reason,
    workitems_0.state,
    workitems_0.teamproject,
    workitems_0.title,
    workitems_0.workitemtype,
    workitems_0.completedwork,
    workitems_0.remainingwork,
    workitems_0.originalestimate,
    workitems_0.resolveddate,
    workitems_0.closeddate,
    workitems_0.private,
    workitems_0.isallday,
    workitems_0.type,
    workitems_0.duration,
    workitems_0.resetentry,
    workitems_0.deleted,
    workitems_0.confirmed,
    workitems_0.parent_id,
    workitems_0.parentpath
   FROM iot_planner_workitems workitems_0;


create or replace view "public"."azuredevopsservice_tags2workitems" as  SELECT tags2workitems_0.id,
    tags2workitems_0.tenant,
    tags2workitems_0.tag_title,
    tags2workitems_0.workitem_id
   FROM iot_planner_tags2workitems tags2workitems_0;


create or replace view "public"."azuredevopsservice_workitems" as  SELECT workitems_0.createdat,
    workitems_0.createdby,
    workitems_0.modifiedat,
    workitems_0.modifiedby,
    workitems_0.invoicerelevance,
    workitems_0.bonusrelevance,
    workitems_0.tenant,
    workitems_0.id,
    workitems_0.activateddate,
    workitems_0.activateddatemonth,
    workitems_0.activateddateyear,
    workitems_0.activateddateday,
    workitems_0.completeddate,
    workitems_0.completeddatemonth,
    workitems_0.completeddateyear,
    workitems_0.completeddateday,
    workitems_0.assignedto_userprincipalname,
    workitems_0.changeddate,
    workitems_0.assignedtoname,
    workitems_0.createddate,
    workitems_0.reason,
    workitems_0.state,
    workitems_0.teamproject,
    workitems_0.title,
    workitems_0.workitemtype,
    workitems_0.completedwork,
    workitems_0.remainingwork,
    workitems_0.originalestimate,
    workitems_0.resolveddate,
    workitems_0.closeddate,
    workitems_0.private,
    workitems_0.isallday,
    workitems_0.type,
    workitems_0.duration,
    workitems_0.resetentry,
    workitems_0.deleted,
    workitems_0.confirmed,
    workitems_0.parent_id,
    workitems_0.parentpath
   FROM iot_planner_workitems workitems_0;


create or replace view "public"."durations" as  SELECT cat.id,
    cat.parent_id,
    sum(wi.duration) AS totalduration
   FROM (iot_planner_categories cat
     JOIN iot_planner_workitems wi ON (((wi.parent_id)::text = (cat.id)::text)))
  GROUP BY cat.id, cat.parent_id;


create or replace view "public"."iot_planner_categories_cte" as  WITH RECURSIVE cte AS (
         SELECT iot_planner_categories.id,
            iot_planner_categories.title,
            iot_planner_categories.description,
            iot_planner_categories.reference,
            iot_planner_categories.parent_id,
            iot_planner_categories.levelspecificid AS catnumber,
            iot_planner_categories.title AS path
           FROM iot_planner_categories
          WHERE (iot_planner_categories.parent_id IS NULL)
        UNION
         SELECT this.id,
            this.title,
            this.description,
            this.reference,
            this.parent_id,
            ((((prior.catnumber)::text || '-'::text) || (this.levelspecificid)::text))::character varying(5000) AS catnumber,
            ((((prior.path)::text || ' > '::text) || (this.title)::text))::character varying(5000) AS path
           FROM (cte prior
             JOIN iot_planner_categories this ON (((this.parent_id)::text = (prior.id)::text)))
        )
 SELECT cte.id,
    cte.title,
    cte.description,
    cte.reference,
    cte.parent_id,
    cte.catnumber,
    cte.path
   FROM cte;


create or replace view "public"."iot_planner_categories_total_durations" as  SELECT sub.id,
    sub.parent_id,
    sub.totalduration
   FROM ( WITH RECURSIVE cte AS (
                 SELECT durations.id,
                    durations.parent_id,
                    durations.totalduration
                   FROM durations
                UNION ALL
                 SELECT this.id,
                    this.parent_id,
                    this.totalduration
                   FROM (durations this
                     JOIN cte prior ON (((prior.parent_id)::text = (this.id)::text)))
                )
         SELECT cte.id,
            cte.parent_id,
            sum(cte.totalduration) AS totalduration
           FROM cte
          GROUP BY cte.id, cte.parent_id) sub;


create or replace view "public"."iot_planner_categoriesaggr" as  SELECT cte.id,
    cte.title,
    cte.description,
    cte.reference,
    cte.parent_id,
    cte.catnumber,
    cte.path,
    (dur.totalduration)::integer AS totalduration
   FROM (iot_planner_categories_cte cte
     LEFT JOIN iot_planner_categories_total_durations dur ON (((cte.id)::text = (dur.id)::text)));


create or replace view "public"."iot_planner_categorytags" as  SELECT tags2categories_0.category_id AS categoryid,
    tags2categories_0.tenant,
    string_agg((tags2categories_0.tag_title)::text, ' '::text) AS tags
   FROM iot_planner_tags2categories tags2categories_0
  GROUP BY tags2categories_0.category_id, tags2categories_0.tenant;


create or replace view "public"."iot_planner_hierarchies_hierarchies" as  SELECT categories_0.id,
        CASE parent_1.hierarchylevel
            WHEN '0'::text THEN parent_1.id
            WHEN '1'::text THEN parent_2.id
            WHEN '2'::text THEN parent_3.id
            WHEN '3'::text THEN parent_4.id
            ELSE NULL::character varying
        END AS level0,
        CASE parent_1.hierarchylevel
            WHEN '1'::text THEN parent_1.id
            WHEN '2'::text THEN parent_2.id
            WHEN '3'::text THEN parent_3.id
            ELSE NULL::character varying
        END AS level1,
        CASE parent_1.hierarchylevel
            WHEN '2'::text THEN parent_1.id
            WHEN '3'::text THEN parent_2.id
            ELSE NULL::character varying
        END AS level2,
        CASE parent_1.hierarchylevel
            WHEN '3'::text THEN parent_1.id
            ELSE NULL::character varying
        END AS level3,
        CASE parent_1.hierarchylevel
            WHEN '0'::text THEN parent_1.title
            WHEN '1'::text THEN parent_2.title
            WHEN '2'::text THEN parent_3.title
            WHEN '3'::text THEN parent_4.title
            ELSE NULL::character varying
        END AS level0title,
        CASE parent_1.hierarchylevel
            WHEN '1'::text THEN parent_1.title
            WHEN '2'::text THEN parent_2.title
            WHEN '3'::text THEN parent_3.title
            ELSE NULL::character varying
        END AS level1title,
        CASE parent_1.hierarchylevel
            WHEN '2'::text THEN parent_1.title
            WHEN '3'::text THEN parent_2.title
            ELSE NULL::character varying
        END AS level2title,
        CASE parent_1.hierarchylevel
            WHEN '3'::text THEN parent_1.title
            ELSE NULL::character varying
        END AS level3title,
        CASE parent_1.hierarchylevel
            WHEN '0'::text THEN parent_1.mappingid
            WHEN '1'::text THEN parent_2.mappingid
            WHEN '2'::text THEN parent_3.mappingid
            WHEN '3'::text THEN parent_4.mappingid
            ELSE NULL::character varying
        END AS level0mappingid,
        CASE parent_1.hierarchylevel
            WHEN '1'::text THEN parent_1.mappingid
            WHEN '2'::text THEN parent_2.mappingid
            WHEN '3'::text THEN parent_3.mappingid
            ELSE NULL::character varying
        END AS level1mappingid,
        CASE parent_1.hierarchylevel
            WHEN '2'::text THEN parent_1.mappingid
            WHEN '3'::text THEN parent_2.mappingid
            ELSE NULL::character varying
        END AS level2mappingid,
        CASE parent_1.hierarchylevel
            WHEN '3'::text THEN parent_1.mappingid
            ELSE NULL::character varying
        END AS level3mappingid
   FROM ((((iot_planner_categories categories_0
     LEFT JOIN iot_planner_categories parent_1 ON (((categories_0.parent_id)::text = (parent_1.id)::text)))
     LEFT JOIN iot_planner_categories parent_2 ON (((parent_1.parent_id)::text = (parent_2.id)::text)))
     LEFT JOIN iot_planner_categories parent_3 ON (((parent_2.parent_id)::text = (parent_3.id)::text)))
     LEFT JOIN iot_planner_categories parent_4 ON (((parent_3.parent_id)::text = (parent_4.id)::text)));


create or replace view "public"."iot_planner_my_categories" as  SELECT sub.id,
    sub.title,
    sub.description,
    sub.reference,
    sub.parent_id,
    sub.catnumber,
    sub.path,
    sub.user_userprincipalname
   FROM ( WITH RECURSIVE childrencte AS (
                 SELECT cat.id,
                    cat.parent_id,
                    user2cat.user_userprincipalname
                   FROM (iot_planner_categories cat
                     JOIN iot_planner_users2categories user2cat ON (((cat.id)::text = (user2cat.category_id)::text)))
                UNION
                 SELECT this.id,
                    this.parent_id,
                    parent.user_userprincipalname
                   FROM (childrencte parent
                     JOIN iot_planner_categories this ON (((this.parent_id)::text = (parent.id)::text)))
                ), parentcte AS (
                 SELECT cat.id,
                    cat.parent_id,
                    user2cat.user_userprincipalname
                   FROM (iot_planner_categories cat
                     JOIN iot_planner_users2categories user2cat ON (((cat.id)::text = (user2cat.category_id)::text)))
                UNION
                 SELECT this.id,
                    this.parent_id,
                    children.user_userprincipalname
                   FROM (parentcte children
                     JOIN iot_planner_categories this ON (((children.parent_id)::text = (this.id)::text)))
                ), pathcte AS (
                 SELECT iot_planner_categories_cte.id,
                    iot_planner_categories_cte.title,
                    iot_planner_categories_cte.description,
                    iot_planner_categories_cte.reference,
                    iot_planner_categories_cte.parent_id,
                    iot_planner_categories_cte.catnumber,
                    iot_planner_categories_cte.path
                   FROM iot_planner_categories_cte
                )
         SELECT pathcte.id,
            pathcte.title,
            pathcte.description,
            pathcte.reference,
            pathcte.parent_id,
            pathcte.catnumber,
            pathcte.path,
            childrencte.user_userprincipalname
           FROM (pathcte
             JOIN childrencte ON (((pathcte.id)::text = (childrencte.id)::text)))
        UNION
         SELECT pathcte.id,
            pathcte.title,
            pathcte.description,
            pathcte.reference,
            pathcte.parent_id,
            pathcte.catnumber,
            pathcte.path,
            parentcte.user_userprincipalname
           FROM (pathcte
             JOIN parentcte ON (((pathcte.id)::text = (parentcte.id)::text)))) sub;


create or replace view "public"."iot_planner_my_categories_with_tags" as  SELECT cat.id,
    cat.title,
    cat.description,
    cat.reference,
    cat.parent_id,
    cat.catnumber,
    cat.path,
    cat.user_userprincipalname,
    string_agg((t2c.tag_title)::text, ' '::text) AS tags
   FROM (iot_planner_my_categories cat
     LEFT JOIN iot_planner_tags2categories t2c ON (((cat.id)::text = (t2c.category_id)::text)))
  GROUP BY cat.id, cat.title, cat.parent_id, cat.description, cat.reference, cat.path, cat.catnumber, cat.user_userprincipalname;


create or replace view "public"."timetrackingservice_categories" as  SELECT categories_0.id,
    categories_0.createdat,
    categories_0.createdby,
    categories_0.modifiedat,
    categories_0.modifiedby,
    categories_0.invoicerelevance,
    categories_0.bonusrelevance,
    categories_0.tenant,
    categories_0.title,
    categories_0.description,
    categories_0.reference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.levelspecificid,
    categories_0.catnumber,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


create or replace view "public"."timetrackingservice_categorylevels" as  SELECT categorylevels_0.tenant,
    categorylevels_0.hierarchylevel,
    categorylevels_0.title
   FROM iot_planner_categorylevels categorylevels_0;


create or replace view "public"."timetrackingservice_mycategories" as  SELECT categories_0.id,
    categories_0.createdat,
    categories_0.createdby,
    categories_0.modifiedat,
    categories_0.modifiedby,
    categories_0.invoicerelevance,
    categories_0.bonusrelevance,
    categories_0.tenant,
    categories_0.title,
    categories_0.description,
    categories_0.reference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.levelspecificid,
    categories_0.catnumber,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


create or replace view "public"."timetrackingservice_myuser" as  SELECT users_0.tenant,
    users_0.userprincipalname,
    users_0.displayname,
    users_0.givenname,
    users_0.jobtitle,
    users_0.mail,
    users_0.mobilephone,
    users_0.officelocation,
    users_0.preferredlanguage,
    users_0.surname,
    users_0.manager_userprincipalname
   FROM iot_planner_users users_0;


create or replace view "public"."timetrackingservice_myworkitems" as  SELECT workitems_0.createdat,
    workitems_0.createdby,
    workitems_0.modifiedat,
    workitems_0.modifiedby,
    workitems_0.invoicerelevance,
    workitems_0.bonusrelevance,
    workitems_0.tenant,
    workitems_0.id,
    workitems_0.activateddate,
    workitems_0.activateddatemonth,
    workitems_0.activateddateyear,
    workitems_0.activateddateday,
    workitems_0.completeddate,
    workitems_0.completeddatemonth,
    workitems_0.completeddateyear,
    workitems_0.completeddateday,
    workitems_0.assignedto_userprincipalname,
    workitems_0.changeddate,
    workitems_0.assignedtoname,
    workitems_0.createddate,
    workitems_0.reason,
    workitems_0.state,
    workitems_0.teamproject,
    workitems_0.title,
    workitems_0.workitemtype,
    workitems_0.completedwork,
    workitems_0.remainingwork,
    workitems_0.originalestimate,
    workitems_0.resolveddate,
    workitems_0.closeddate,
    workitems_0.private,
    workitems_0.isallday,
    workitems_0.type,
    workitems_0.duration,
    workitems_0.resetentry,
    workitems_0.deleted,
    workitems_0.confirmed,
    workitems_0.parent_id,
    workitems_0.parentpath
   FROM iot_planner_workitems workitems_0;


create or replace view "public"."timetrackingservice_tags" as  SELECT tags_0.tenant,
    tags_0.title,
    tags_0.category_id,
    tags_0.workitem_id
   FROM iot_planner_tags tags_0;


create or replace view "public"."timetrackingservice_tags2categories" as  SELECT tags2categories_0.id,
    tags2categories_0.tenant,
    tags2categories_0.tag_title,
    tags2categories_0.category_id
   FROM iot_planner_tags2categories tags2categories_0;


create or replace view "public"."timetrackingservice_tags2workitems" as  SELECT tags2workitems_0.id,
    tags2workitems_0.tenant,
    tags2workitems_0.tag_title,
    tags2workitems_0.workitem_id
   FROM iot_planner_tags2workitems tags2workitems_0;


create or replace view "public"."timetrackingservice_users2categories" as  SELECT users2categories_0.id,
    users2categories_0.createdat,
    users2categories_0.createdby,
    users2categories_0.modifiedat,
    users2categories_0.modifiedby,
    users2categories_0.tenant,
    users2categories_0.user_userprincipalname,
    users2categories_0.category_id
   FROM iot_planner_users2categories users2categories_0;


create or replace view "public"."workitemsservice_categories" as  SELECT categories_0.id,
    categories_0.createdat,
    categories_0.createdby,
    categories_0.modifiedat,
    categories_0.modifiedby,
    categories_0.invoicerelevance,
    categories_0.bonusrelevance,
    categories_0.tenant,
    categories_0.title,
    categories_0.description,
    categories_0.reference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.levelspecificid,
    categories_0.catnumber,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


create or replace view "public"."workitemsservice_hierarchies" as  SELECT hierarchies_0.id,
    hierarchies_0.level0,
    hierarchies_0.level1,
    hierarchies_0.level2,
    hierarchies_0.level3,
    hierarchies_0.level0title,
    hierarchies_0.level1title,
    hierarchies_0.level2title,
    hierarchies_0.level3title,
    hierarchies_0.level0mappingid,
    hierarchies_0.level1mappingid,
    hierarchies_0.level2mappingid,
    hierarchies_0.level3mappingid
   FROM iot_planner_hierarchies_hierarchies hierarchies_0;


create or replace view "public"."workitemsservice_iotworkitems" as  SELECT workitems_0.activateddate AS datum,
    workitems_0.completeddate AS datumbis,
    ''::text AS beginn,
    ''::text AS ende,
    ''::text AS p1,
    hierarchy_1.level1mappingid AS projekt,
    hierarchy_1.level2mappingid AS teilprojekt,
    hierarchy_1.level3mappingid AS arbeitspaket,
    'Durchf�hrung'::text AS taetigkeit,
    assignedto_2.userprincipalname AS nutzer,
    'GE'::text AS einsatzort,
    workitems_0.title AS bemerkung,
    workitems_0.tenant,
    assignedto_2.manager_userprincipalname AS manageruserprincipalname,
    workitems_0.id
   FROM ((iot_planner_workitems workitems_0
     LEFT JOIN iot_planner_hierarchies_hierarchies hierarchy_1 ON (((workitems_0.parent_id)::text = (hierarchy_1.id)::text)))
     LEFT JOIN iot_planner_users assignedto_2 ON (((workitems_0.assignedto_userprincipalname)::text = (assignedto_2.userprincipalname)::text)))
  WHERE (workitems_0.deleted IS NULL);


create or replace view "public"."workitemsservice_tags2workitems" as  SELECT tags2workitems_0.id,
    tags2workitems_0.tenant,
    tags2workitems_0.tag_title,
    tags2workitems_0.workitem_id
   FROM iot_planner_tags2workitems tags2workitems_0;


create or replace view "public"."workitemsservice_users" as  SELECT users_0.tenant,
    users_0.userprincipalname,
    users_0.displayname,
    users_0.givenname,
    users_0.jobtitle,
    users_0.mail,
    users_0.mobilephone,
    users_0.officelocation,
    users_0.preferredlanguage,
    users_0.surname,
    users_0.manager_userprincipalname
   FROM iot_planner_users users_0;


create or replace view "public"."workitemsservice_workitems" as  SELECT workitems_0.createdat,
    workitems_0.createdby,
    workitems_0.modifiedat,
    workitems_0.modifiedby,
    workitems_0.invoicerelevance,
    workitems_0.bonusrelevance,
    workitems_0.tenant,
    workitems_0.id,
    workitems_0.activateddate,
    workitems_0.activateddatemonth,
    workitems_0.activateddateyear,
    workitems_0.activateddateday,
    workitems_0.completeddate,
    workitems_0.completeddatemonth,
    workitems_0.completeddateyear,
    workitems_0.completeddateday,
    workitems_0.assignedto_userprincipalname,
    workitems_0.changeddate,
    workitems_0.assignedtoname,
    workitems_0.createddate,
    workitems_0.reason,
    workitems_0.state,
    workitems_0.teamproject,
    workitems_0.title,
    workitems_0.workitemtype,
    workitems_0.completedwork,
    workitems_0.remainingwork,
    workitems_0.originalestimate,
    workitems_0.resolveddate,
    workitems_0.closeddate,
    workitems_0.private,
    workitems_0.isallday,
    workitems_0.type,
    workitems_0.duration,
    workitems_0.resetentry,
    workitems_0.deleted,
    workitems_0.confirmed,
    workitems_0.parent_id,
    workitems_0.parentpath,
    assignedto_1.userprincipalname AS assignedtouserprincipalname,
    assignedto_1.manager_userprincipalname AS manageruserprincipalname
   FROM (iot_planner_workitems workitems_0
     LEFT JOIN iot_planner_users assignedto_1 ON (((workitems_0.assignedto_userprincipalname)::text = (assignedto_1.userprincipalname)::text)))
  WHERE (workitems_0.deleted IS NULL);


create or replace view "public"."adminservice_categoriesaggr" as  SELECT categoriesaggr_0.id,
    categoriesaggr_0.title,
    categoriesaggr_0.description,
    categoriesaggr_0.reference,
    categoriesaggr_0.parent_id,
    categoriesaggr_0.catnumber,
    categoriesaggr_0.path,
    categoriesaggr_0.totalduration
   FROM iot_planner_categoriesaggr categoriesaggr_0;


create or replace view "public"."analyticsservice_categories" as  SELECT cat_0.id,
    wi_1.assignedtouserprincipalname,
    wi_1.activateddate,
    wi_1.completeddate,
    wi_1.activateddatemonth,
    wi_1.activateddateyear,
    wi_1.duration,
    cat_0.title AS parenttitle,
    cat_0.parent_id,
    wi_1.assignedto_userprincipalname,
    'expanded'::text AS drilldownstate,
    cat_0.hierarchylevel,
    cat_0.tenant
   FROM (workitemsservice_categories cat_0
     LEFT JOIN workitemsservice_workitems wi_1 ON (((wi_1.parent_id)::text = (cat_0.id)::text)))
  WHERE (wi_1.deleted IS NULL);


create or replace view "public"."analyticsservice_users" as  SELECT users_0.tenant,
    users_0.userprincipalname,
    users_0.displayname,
    users_0.givenname,
    users_0.jobtitle,
    users_0.mail,
    users_0.mobilephone,
    users_0.officelocation,
    users_0.preferredlanguage,
    users_0.surname,
    users_0.manager_userprincipalname
   FROM workitemsservice_users users_0;



