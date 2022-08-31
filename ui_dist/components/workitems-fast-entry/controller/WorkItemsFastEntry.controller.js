function addMinutes(e,t){return new Date(e.getTime()+t*6e4)}sap.ui.define(["./BaseController","../model/formatter","sap/ui/model/Filter","sap/ui/model/FilterOperator","sap/m/MessageToast"],(e,t,r,s,a)=>e.extend("iot.workitemsfastentry.controller.WorkItemsFastEntry",{formatter:t,async onInit(){this._filterHierarchyByPath("hierarchyTreeForm","");this.searchFilters=[];this._filters={all:new r({path:"state",operator:"NE",value1:""}),completed:new r({path:"state",operator:"EQ",value1:"completed"}),incompleted:new r({path:"state",operator:"EQ",value1:"incompleted"})}},async onBeforeRendering(){const e=this.getModel();const t=new Date;t.setHours(0,0,0,0);const r=new Date;r.setHours(24,0,0,0);const s=new Date;const a=addMinutes(new Date,15);e.setData({busy:false,tableBusy:true,showHierarchyTreeForm:false,showHierarchyTreeTable:false,MyCategories:{},categoriesNested:{},activities:[{title:"Durchführung"},{title:"Reise-/Fahrzeit"},{title:"Pendelfahrt Hotel/Einsatzort"}],locations:[{title:"IOT"},{title:"Home-Office"},{title:"Rottendorf"}],countAll:undefined,countCompleted:undefined,countIncompleted:undefined,newWorkItem:{title:"",parentPath:"",tags:[],activatedDate:s,completedDate:a,state:"incompleted"}});await Promise.all([this._loadWorkItems({startDateTime:t,endDateTime:r}),this._loadHierarchy()]);e.setProperty("/tableBusy",false)},async _loadWorkItems({startDateTime:e,endDateTime:t}){const r=this.getModel();const{results:s}=await r.callFunction("/getCalendarView",{urlParameters:{startDateTime:e,endDateTime:t}});const a=s.map(({completedDate:e,activatedDate:t,isAllDay:r,...s})=>({...s,tags:s.tags.results,completedDate:r?e.setHours(0):e,activatedDate:r?t.setHours(0):t}));r.setProperty("/MyWorkItems",a)},async _loadHierarchy(){const e=this.getModel();const{results:t}=await e.callFunction("/getMyCategoryTree");const r=e.nest({items:t});e.setProperty("/MyCategories",t);e.setProperty("/MyCategoriesNested",r)},calculateActivatedDate(){const e=this.getModel();const t=e.getProperty("/MyWorkItems").map(e=>({...e}));const r=t.reduce((e,t)=>{if(e===undefined){return t.completedDate}return t.completedDate>e?t.completedDate:e},undefined);let s=r;const a=new Date;if(s.toDateString()!==a.toDateString()){s=a;s.setHours(8,30,0);if(a.getTime()<s.getTime()){s=a}}return s},async setItemCountsFilters(e){const t=this.getModel();const r=t.getProperty("/MyWorkItems").filter(e=>e.state!=="").length;const s=t.getProperty("/MyWorkItems").filter(e=>e.state==="completed").length;const a=t.getProperty("/MyWorkItems").filter(e=>e.state==="incompleted").length;t.setProperty("/countAll",r);t.setProperty("/countCompleted",s);t.setProperty("/countIncompleted",a)},onChangeHierarchy(e){let t;if(e.getParameter("id").endsWith("Form")){this.getModel().setProperty("/showHierarchyTreeForm",true);t="hierarchyTreeForm";const{newValue:r}=e.getParameters();this._filterHierarchyByPath(t,r)}},_filterHierarchyByPath(e,t){const s=[new r({path:"path",test:e=>{if(!t)return false;const r=t.split(" ");return r.map(e=>e.toUpperCase()).every(t=>e.includes(t))}})];this.byId(e).getBinding("items").filter(s)},onSelectHierarchy(e){if(e.getParameter("id").endsWith("Form")){const{listItem:t}=e.getParameters();const r=t.getBindingContext().getProperty("path");this.getModel().setProperty("/newWorkItem/parentPath",r)}else{const{listItem:t}=e.getParameters();const r=t.getBindingContext().getProperty("path");const s=e.getSource().getBindingContext().getPath();this.getModel().setProperty(`${s}/parentPath`,r)}},onChangeDate(e){const t=this.getModel();const r=t.getProperty("/newWorkItem/date");const s=t.getProperty("/newWorkItem/activatedDate");const a=t.getProperty("/newWorkItem/completedDate");t.setProperty("/newWorkItem/activatedDate",this.updateDate(s,r));t.setProperty("/newWorkItem/completedDate",this.updateDate(a,r))},updateDate(e,t){const r=new Date(t.getTime());const s=e.getHours();const a=e.getMinutes();const o=e.getSeconds();r.setHours(s,a,o);return r},onFilterWorkItems(e){const t=this.byId("tableWorkItems").getBinding("items");const r=e.getParameter("selectedKey");t.filter(this._filters[r])},onSearch(e){this.searchFilters=[];this.searchQuery=e.getSource().getValue();if(this.searchQuery&&this.searchQuery.length>0){this.searchFilters=new r("text",s.Contains,this.searchQuery)}this.byId("table").getBinding("items").filter(this.searchFilters)},async addWorkItem(){const e=this.getModel();const t=e.getProperty("/newWorkItem");e.setProperty("/busy",true);await e.create("/MyWorkItems",{localPath:"/MyWorkItems/X",...t});e.setProperty("/newWorkItem",{});e.setProperty("/busy",false)},async updateWorkItem(e){const t=e.getSource().getBindingContext();const r=t.getPath();const s=t.getObject();await this.getModel().update({...s,localPath:r})},async onPressDeleteWorkItems(){const e=this.getModel();const t=this.byId("tableWorkItems");const r=t.getSelectedContexts().map(e=>e.getObject());await Promise.all(r.map(t=>{if(t.type==="Manual")return e.remove(t);return e.callFunction("/removeDraft",{method:"POST",urlParameters:{ID:t.ID,activatedDate:t.activatedDate,completedDate:t.completedDate}})}));const s=e.getProperty("/MyWorkItems").filter(e=>{const t=!r.map(e=>e.__metadata.uri).includes(e.__metadata.uri);return t});e.setProperty("/MyWorkItems",s);t.removeSelections();a.show(`Deleted ${r.length} work items.`)}}));