drop view if exists "public"."timetrackingservice_matchcategory2tags";

drop view if exists "public"."iot_planner_matchcategory2tags";

drop view if exists "public"."iot_planner_categories2tagsorderedbytags";

create or replace view "public"."iot_planner_categorytags" as  SELECT tags2categories_0.category_id AS categoryid,
    tags2categories_0.tenant,
    string_agg((tags2categories_0.tag_title)::text, ' '::text) AS tags
   FROM iot_planner_tags2categories tags2categories_0
  GROUP BY tags2categories_0.category_id, tags2categories_0.tenant;


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
    assignedto_2.manager_userprincipalname AS manageruserprincipalname,
    workitems_0.id
   FROM ((iot_planner_workitems workitems_0
     LEFT JOIN iot_planner_hierarchies_hierarchies hierarchy_1 ON (((workitems_0.parent_id)::text = (hierarchy_1.parent)::text)))
     LEFT JOIN iot_planner_users assignedto_2 ON (((workitems_0.assignedto_userprincipalname)::text = (assignedto_2.userprincipalname)::text)))
  WHERE (workitems_0.deleted IS NULL);



