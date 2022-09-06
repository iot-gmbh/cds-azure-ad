using {
  Currency,
  cuid,
  managed,
  sap,
} from '@sap/cds/common';

namespace iot.planner;

using {iot.planner.hierarchies.Hierarchies as Hierarchies} from './hierarchies';

aspect relevance {
  invoiceRelevance : Decimal(2, 1) @(
    title        : '{i18n>relevance.invoiceRelevance}',
    assert.range : [
      0,
      1
    ],
  );
  bonusRelevance   : Decimal(2, 1) @(
    title        : '{i18n>relevance.bonusRelevance}',
    assert.range : [
      0,
      1
    ],
  );
};

aspect multitenant {
  tenant : String
}

@assert.unique : {friendlyID : [userPrincipalName, ]}
entity Users : multitenant {
  key userPrincipalName : String;
      displayName       : String;
      givenName         : String;
      jobTitle          : String;
      mail              : String;
      mobilePhone       : String;
      officeLocation    : String;
      preferredLanguage : String;
      surname           : String;
      manager           : Association to Users;
      categories        : Association to many Users2Categories
                            on categories.user = $self;
      teamMembers       : Association to many Users
                            on teamMembers.manager = $self;
      workItems         : Association to many WorkItems
                            on workItems.assignedTo = $self;
      travels           : Association to many Travels
                            on travels.user = $self;
};

entity Users2Categories : cuid, managed, multitenant {
  user     : Association to Users;
  category : Association to Categories;
}

@assert.unique : {ID : [ID]} // set explicit unique-constraint on ID. If we don't do this, Postgres will throw an error when upserting data ("es gibt keinen Unique-Constraint oder Exclusion-Constraint, der auf die ON-CONFLICT-Angabe passt"). See: https://stackoverflow.com/questions/42022362/no-unique-or-exclusion-constraint-matching-the-on-conflict
entity Categories : cuid, managed, relevance, multitenant {
  title               : String;
  description         : String;
  absoluteReference   : String;
  mappingID           : String;
  drillDownState      : String default 'expanded';
  path                : String;
  hierarchyLevel      : String;
  shallowReference    : String;
  deepReference       : String;
  totalDuration       : Decimal;
  accumulatedDuration : Decimal;
  relativeDuration    : Decimal;
  relativeAccDuration : Decimal;
  grandTotal          : Decimal;
  validFrom           : DateTime;
  validTo             : DateTime;
  level               : Association to CategoryLevels
                          on hierarchyLevel = level.hierarchyLevel;
  tags                : Association to many Tags2Categories
                          on tags.category = $self;
  @assert.notNull : false
  manager             : Association to Users;
  members             : Association to many Users2Categories
                          on members.category = $self;
  @assert.notNull : false
  parent              : Association to Categories;
  children            : Composition of many Categories
                          on children.parent = $self;
}

entity CategoriesCumulativeDurations as projection on Categories {
  key ID,
      tenant,
      parent,
      title,
      cast('2021-05-02 14:55:08.091' as DateTime) as activatedDate                : DateTime,
      cast('2021-05-02 14:55:08.091' as DateTime) as completedDate                : DateTime,
      cast('' as                        String)   as assignedTo_userPrincipalName : String,
      // members,
      // tags,
      children,
      // shallowReference as deepReference,
      // title           as path,
      totalDuration
}

entity Tags : multitenant {
  key title    : String;
      category : Association to Categories;
      workItem : Association to WorkItems;
}

entity Tags2Categories : cuid, multitenant {
  tag      : Association to Tags;
  category : Association to Categories;
}

entity Tags2WorkItems : cuid, multitenant {
  tag      : Association to Tags;
  workItem : Association to WorkItems;
}

view CategoryTags as
  select from Tags2Categories {
    key category.ID       as categoryID : String,
        tenant                          : String,
        // TODO: Make independent of DB (string_agg) is a postgres-function
        string_agg(
          tag.title, ' ') as tags       : String,
    }
    group by
      category.ID,
      tenant;

entity WorkItems : managed, relevance, multitenant {
  key ID                 : String @odata.Type : 'Edm.String';
      tags               : Composition of many Tags2WorkItems
                             on tags.workItem = $self;
      date               : Date;
      activatedDate      : DateTime;
      activatedDateTime  : Time;
      activatedDateMonth : Integer;
      activatedDateYear  : Integer;
      activatedDateDay   : Integer;
      completedDate      : DateTime;
      completedDateTime  : Time;
      completedDateMonth : Integer;
      completedDateYear  : Integer;
      completedDateDay   : Integer;
      assignedTo         : Association to Users;
      changedDate        : DateTime;
      assignedToName     : String;
      createdDate        : DateTime;
      reason             : String;
      state              : String;
      teamProject        : String;
      title              : String;
      workItemType       : String;
      // Scheduling
      completedWork      : Decimal;
      remainingWork      : Decimal;
      originalEstimate   : Decimal;
      // Documentation
      resolvedDate       : DateTime;
      closedDate         : DateTime;
      private            : Boolean;
      isPrivate          : Boolean;
      isAllDay           : Boolean;
      // Custom
      type               : String enum {
        Manual;
        Event;
        WorkItem
      };
      source             : String enum {
        Manual;
        MSGraphEvent;
        AzureDevopsWorkItem;
      //...
      };
      duration           : Decimal;
      resetEntry         : Boolean;
      deleted            : Boolean;
      confirmed          : Boolean;
      parent             : Association to Categories;
      hierarchy          : Association to Hierarchies
                             on parent.ID = hierarchy.ID;
      // Used by the Frontend's hierarchy input-filter
      parentPath         : String;
};

entity CategoryLevels : multitenant {
  key hierarchyLevel : String;
      title          : String;
}

entity Travels : cuid, managed, multitenant {
  user   : Association to Users;
  parent : Association to Categories;
}
