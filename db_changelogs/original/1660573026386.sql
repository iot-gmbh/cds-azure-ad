drop view if exists "public"."adminservice_categories";

drop view if exists "public"."adminservice_hierarchies";

drop view if exists "public"."azuredevopsservice_categories";

drop view if exists "public"."azuredevopsservice_hierarchies";

drop function if exists "public"."get_categories"(p_tenant character varying, p_root character varying, p_valid_at timestamp with time zone);

drop view if exists "public"."iot_planner_categoriescumulativedurations";

drop view if exists "public"."iot_planner_my_categories_with_tags";

drop view if exists "public"."timetrackingservice_categories";

drop view if exists "public"."timetrackingservice_hierarchies";

drop view if exists "public"."timetrackingservice_mycategories";

drop view if exists "public"."workitemsservice_categories";

drop view if exists "public"."workitemsservice_hierarchies";

drop view if exists "public"."workitemsservice_iotworkitems";

drop view if exists "public"."iot_planner_hierarchies_hierarchies";

drop view if exists "public"."iot_planner_my_categories";

drop view if exists "public"."iot_planner_categories_cte";

alter table "public"."iot_planner_categories" drop column "reference";

alter table "public"."iot_planner_categories" add column "absolutereference" character varying(5000);

set check_function_bodies = off;

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
    categories_0.absolutereference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.shallowreference,
    categories_0.deepreference,
    categories_0.totalduration,
    categories_0.accumulatedduration,
    categories_0.relativeduration,
    categories_0.relativeaccduration,
    categories_0.grandtotal,
    categories_0.validfrom,
    categories_0.validto,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


create or replace view "public"."azuredevopsservice_categories" as  SELECT categories_0.id,
    categories_0.createdat,
    categories_0.createdby,
    categories_0.modifiedat,
    categories_0.modifiedby,
    categories_0.invoicerelevance,
    categories_0.bonusrelevance,
    categories_0.tenant,
    categories_0.title,
    categories_0.description,
    categories_0.absolutereference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.shallowreference,
    categories_0.deepreference,
    categories_0.totalduration,
    categories_0.accumulatedduration,
    categories_0.relativeduration,
    categories_0.relativeaccduration,
    categories_0.grandtotal,
    categories_0.validfrom,
    categories_0.validto,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


CREATE OR REPLACE FUNCTION public.get_categories(p_tenant character varying, p_root character varying DEFAULT NULL::character varying, p_valid_at timestamp with time zone DEFAULT now())
 RETURNS TABLE(id character varying, tenant character varying, parent_id character varying, title character varying, hierarchylevel character varying, description character varying, absolutereference character varying, deepreference character varying, path character varying)
 LANGUAGE plpgsql
AS $function$ #variable_conflict use_column
begin RETURN QUERY WITH RECURSIVE cte AS (
    SELECT
        ID,
        tenant,
        parent_ID,
        title,
        hierarchyLevel,
        description,
        absoluteReference,
        shallowReference as deepReference,
        title as path
    FROM
        iot_planner_Categories
    WHERE
        -- if p_root is null (=> in case you want to get all elements of level 0), then parent_ID = null will return no results => in this case check for "parent_ID IS NULL"
        tenant = p_tenant
        and validFrom <= p_valid_at
        and validTo > p_valid_at
        and (
            p_root is null
            and parent_ID is null
            or parent_ID = p_root
        )
    UNION
    SELECT
        this.ID,
        this.tenant,
        this.parent_ID,
        this.title,
        this.hierarchyLevel,
        this.description,
        this.absoluteReference,
        CAST(
            (prior.deepReference || '-' || this.shallowReference) as varchar(5000)
        ) as deepReference,
        CAST(
            (prior.path || ' > ' || this.title) as varchar(5000)
        ) as path
    FROM
        cte AS prior
        INNER JOIN iot_planner_Categories AS this ON this.parent_ID = prior.ID
        and this.tenant = p_tenant
        and this.validFrom <= p_valid_at
        and this.validTo > p_valid_at
)
SELECT
    cte.*
FROM
    cte;

end $function$
;

CREATE OR REPLACE FUNCTION public.get_cumulative_category_durations(p_tenant character varying, p_username character varying, p_date_from timestamp with time zone, p_date_until timestamp with time zone)
 RETURNS TABLE(id character varying, tenant character varying, parent_id character varying, title character varying, hierarchylevel character varying, totalduration numeric, accumulatedduration numeric)
 LANGUAGE plpgsql
AS $function$ #variable_conflict use_column
begin RETURN QUERY
/* for reference: https://stackoverflow.com/questions/26660189/recursive-query-with-sum-in-postgres */
WITH RECURSIVE cte AS (
    SELECT
        ID,
        ID as parent_ID,
        tenant,
        parent_ID as parent,
        title,
        hierarchyLevel,
        totalDuration,
        totalDuration as accumulatedDuration
    FROM
        get_durations(p_username, p_tenant, p_date_from, p_date_until)
    UNION
	ALL
    SELECT
        c.ID,
        d.ID,
        c.tenant,
        c.parent,
        c.title,
        c.hierarchyLevel,
        c.totalDuration,
        d.totalDuration as accumulatedDuration
    FROM
        cte c
        JOIN get_durations(p_username, p_tenant, p_date_from, p_date_until) d on c.parent_ID = d.parent_ID
)
SELECT
    ID,
    tenant,
    parent as parent_ID,
    title,
    hierarchyLevel,
    totalDuration,
    sum(accumulatedDuration) AS accumulatedDuration
FROM
    cte 
GROUP BY
    ID,
    tenant,
    parent,
    hierarchyLevel,
    totalDuration,
    title;

end $function$
;

CREATE OR REPLACE FUNCTION public.get_cumulative_category_durations_with_path(p_tenant character varying, p_username character varying, p_date_from timestamp with time zone, p_date_until timestamp with time zone)
 RETURNS TABLE(id character varying, tenant character varying, parent_id character varying, title character varying, hierarchylevel character varying, totalduration numeric, accumulatedduration numeric, deepreference character varying)
 LANGUAGE plpgsql
AS $function$ #variable_conflict use_column
begin RETURN QUERY
SELECT
    dur.ID,
    dur.tenant,
    dur.parent_ID,
    dur.title,
    dur.hierarchyLevel,
    dur.totalDuration,
    dur.accumulatedDuration,
    pathCTE.deepReference
FROM
    get_cumulative_category_durations(p_username, p_tenant, p_date_from, p_date_until) as dur
    JOIN iot_planner_categories_cte as pathCTE on pathCTE.ID = dur.ID;
end $function$
;

CREATE OR REPLACE FUNCTION public.get_durations(p_tenant character varying, p_username character varying, p_date_from timestamp with time zone, p_date_until timestamp with time zone)
 RETURNS TABLE(id character varying, tenant character varying, parent_id character varying, title character varying, hierarchylevel character varying, totalduration numeric, datefrom timestamp with time zone, dateuntil timestamp with time zone)
 LANGUAGE plpgsql
AS $function$ #variable_conflict use_column
begin RETURN QUERY
SELECT
    cat.ID,
    cat.tenant,
    cat.parent_ID,
    cat.title,
    cat.hierarchyLevel,
    sum(wi.duration) as totalDuration,
    p_date_from as dateFrom,
    p_date_until as dateUntil
FROM
    iot_planner_categories as cat
    LEFT OUTER JOIN iot_planner_workitems as wi on wi.parent_ID = cat.ID
    and wi.tenant = cat.tenant
    and wi.assignedTo_userPrincipalName ilike p_username
    and wi.activateddate > p_date_from
    and wi.activateddate < p_date_until
where
    wi.tenant = p_tenant
GROUP BY
    cat.ID,
    cat.tenant,
    cat.parent_ID,
    cat.title,
    cat.hierarchyLevel;

end $function$
;

create or replace view "public"."iot_planner_categories_cte" as  WITH RECURSIVE cte AS (
         SELECT iot_planner_categories.id,
            iot_planner_categories.tenant,
            iot_planner_categories.title,
            iot_planner_categories.description,
            iot_planner_categories.parent_id,
            iot_planner_categories.absolutereference,
            iot_planner_categories.shallowreference,
            iot_planner_categories.shallowreference AS deepreference,
            iot_planner_categories.title AS path
           FROM iot_planner_categories
          WHERE (iot_planner_categories.parent_id IS NULL)
        UNION
         SELECT this.id,
            this.tenant,
            this.title,
            this.description,
            this.parent_id,
            this.absolutereference,
            this.shallowreference,
            ((((prior.deepreference)::text || '-'::text) || (this.shallowreference)::text))::character varying(5000) AS deepreference,
            ((((prior.path)::text || ' > '::text) || (this.title)::text))::character varying(5000) AS path
           FROM (cte prior
             JOIN iot_planner_categories this ON (((this.parent_id)::text = (prior.id)::text)))
        )
 SELECT cte.id,
    cte.tenant,
    cte.title,
    cte.description,
    cte.parent_id,
    cte.absolutereference,
    cte.shallowreference,
    cte.deepreference,
    cte.path
   FROM cte;


create or replace view "public"."iot_planner_categoriescumulativedurations" as  SELECT categories_0.id,
    categories_0.tenant,
    categories_0.parent_id,
    categories_0.title,
    '2021-05-02 14:55:08.091+02'::timestamp with time zone AS activateddate,
    '2021-05-02 14:55:08.091+02'::timestamp with time zone AS completeddate,
    ''::character varying(5000) AS assignedto_userprincipalname,
    categories_0.totalduration
   FROM iot_planner_categories categories_0;


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
    sub.tenant,
    sub.title,
    sub.description,
    sub.parent_id,
    sub.absolutereference,
    sub.shallowreference,
    sub.deepreference,
    sub.path,
    sub.user_userprincipalname
   FROM ( WITH RECURSIVE childrencte AS (
                 SELECT cat.id,
                    cat.tenant,
                    cat.parent_id,
                    user2cat.user_userprincipalname
                   FROM (iot_planner_categories cat
                     JOIN iot_planner_users2categories user2cat ON (((cat.id)::text = (user2cat.category_id)::text)))
                  WHERE ((cat.validfrom <= now()) AND (cat.validto > now()))
                UNION
                 SELECT this.id,
                    this.tenant,
                    this.parent_id,
                    parent.user_userprincipalname
                   FROM (childrencte parent
                     JOIN iot_planner_categories this ON ((((this.parent_id)::text = (parent.id)::text) AND (this.validfrom <= now()) AND (this.validto > now()))))
                ), parentcte AS (
                 SELECT cat.id,
                    cat.tenant,
                    cat.parent_id,
                    user2cat.user_userprincipalname
                   FROM (iot_planner_categories cat
                     JOIN iot_planner_users2categories user2cat ON (((cat.id)::text = (user2cat.category_id)::text)))
                  WHERE ((cat.validfrom <= now()) AND (cat.validto > now()))
                UNION
                 SELECT this.id,
                    this.tenant,
                    this.parent_id,
                    children.user_userprincipalname
                   FROM (parentcte children
                     JOIN iot_planner_categories this ON ((((children.parent_id)::text = (this.id)::text) AND (this.validfrom <= now()) AND (this.validto > now()))))
                )
         SELECT pathcte.id,
            pathcte.tenant,
            pathcte.title,
            pathcte.description,
            pathcte.parent_id,
            pathcte.absolutereference,
            pathcte.shallowreference,
            pathcte.deepreference,
            pathcte.path,
            childrencte.user_userprincipalname
           FROM (iot_planner_categories_cte pathcte
             JOIN childrencte ON (((pathcte.id)::text = (childrencte.id)::text)))
        UNION
         SELECT pathcte.id,
            pathcte.tenant,
            pathcte.title,
            pathcte.description,
            pathcte.parent_id,
            pathcte.absolutereference,
            pathcte.shallowreference,
            pathcte.deepreference,
            pathcte.path,
            parentcte.user_userprincipalname
           FROM (iot_planner_categories_cte pathcte
             JOIN parentcte ON (((pathcte.id)::text = (parentcte.id)::text)))) sub;


create or replace view "public"."iot_planner_my_categories_with_tags" as  SELECT cat.id,
    cat.tenant,
    cat.title,
    cat.description,
    cat.parent_id,
    cat.absolutereference,
    cat.shallowreference,
    cat.deepreference,
    cat.path,
    cat.user_userprincipalname,
    string_agg((t2c.tag_title)::text, ' '::text) AS tags
   FROM (iot_planner_my_categories cat
     LEFT JOIN iot_planner_tags2categories t2c ON (((cat.id)::text = (t2c.category_id)::text)))
  GROUP BY cat.id, cat.title, cat.tenant, cat.parent_id, cat.description, cat.absolutereference, cat.path, cat.deepreference, cat.shallowreference, cat.user_userprincipalname;


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
    categories_0.absolutereference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.shallowreference,
    categories_0.deepreference,
    categories_0.totalduration,
    categories_0.accumulatedduration,
    categories_0.relativeduration,
    categories_0.relativeaccduration,
    categories_0.grandtotal,
    categories_0.validfrom,
    categories_0.validto,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


create or replace view "public"."timetrackingservice_hierarchies" as  SELECT hierarchies_0.id,
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
    categories_0.absolutereference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.shallowreference,
    categories_0.deepreference,
    categories_0.totalduration,
    categories_0.accumulatedduration,
    categories_0.relativeduration,
    categories_0.relativeaccduration,
    categories_0.grandtotal,
    categories_0.validfrom,
    categories_0.validto,
    categories_0.manager_userprincipalname,
    categories_0.parent_id
   FROM iot_planner_categories categories_0;


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
    categories_0.absolutereference,
    categories_0.mappingid,
    categories_0.drilldownstate,
    categories_0.path,
    categories_0.hierarchylevel,
    categories_0.shallowreference,
    categories_0.deepreference,
    categories_0.totalduration,
    categories_0.accumulatedduration,
    categories_0.relativeduration,
    categories_0.relativeaccduration,
    categories_0.grandtotal,
    categories_0.validfrom,
    categories_0.validto,
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


create or replace view "public"."adminservice_hierarchies" as  SELECT hierarchies_0.id,
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


create or replace view "public"."azuredevopsservice_hierarchies" as  SELECT hierarchies_0.id,
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



