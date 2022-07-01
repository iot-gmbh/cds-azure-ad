sap.ui.define(["sap/ui/base/Object","sap/m/MessageBox","sap/ui/model/Filter","sap/ui/model/FilterOperator"],(e,s,t,o)=>e.extend("iot.planner.assignuserstocategories.controller.ErrorHandler",{constructor:function(e){const s=sap.ui.getCore().getMessageManager();const n=s.getMessageModel();const r=e.getModel("i18n").getResourceBundle();const i=r.getText("errorText");const a=r.getText("multipleErrorsText");this._oComponent=e;this._bMessageOpen=false;this.oMessageModelBinding=n.bindList("/",undefined,[],new t("technical",o.EQ,true));this.oMessageModelBinding.attachChange(function(e){const t=e.getSource().getContexts();const o=[];if(this._bMessageOpen||!t.length){return}t.forEach(e=>{o.push(e.getObject())});s.removeMessages(o);const n=o.length===1?i:a;this._showServiceError(n,o[0].message)},this)},_showServiceError(e,t){this._bMessageOpen=true;s.error(e,{id:"serviceErrorMessageBox",details:t,styleClass:this._oComponent.getContentDensityClass(),actions:[s.Action.CLOSE],onClose:function(){this._bMessageOpen=false}.bind(this)})}}));