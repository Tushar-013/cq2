import { api } from 'lwc';
import cqRecordForm from 'cqext/cqRecordForm';

import OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT from '@salesforce/schema/compliancequest__SQX_Complaint__c';





import CQTESTBP_SUBMIT from '@salesforce/label/c.CQTESTBP_SUBMIT'; 



import CQTESTBP_INITIATE from '@salesforce/label/c.CQTESTBP_INITIATE'; 





const fields = [
    
];
const FORM_RULES = {};
const objectName = OBJECT_COMPLIANCEQUEST__SQX_COMPLAINT;

export default class cquitestBPComplaintNba extends cqRecordForm {
    constructor() {
        super();
        this.init(objectName, fields);
        this.inputFormRules = FORM_RULES;
    }
    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        if (value) {
            this._recordId = value;
            this.parentId = value;
        }
    }

    
    
    
    
    get CQTESTBP_SUBMIT() {
        return CQTESTBP_SUBMIT;
    }
    
    
    
    
    
    get CQTESTBP_INITIATE() {
        return CQTESTBP_INITIATE;
    }
    
    
   
}