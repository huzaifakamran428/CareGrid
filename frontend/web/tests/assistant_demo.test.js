/* No external test dependencies; exercises the actual assistant API in an isolated VM. */
const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const path=require('node:path');
const data=new Map();
const sandbox={
  window:{},
  document:{body:{dataset:{}}},
  localStorage:{
    getItem:k=>data.has(k)?data.get(k):null,
    setItem:(k,v)=>data.set(k,String(v)),
  },
  Date,Math,JSON
};
const file=path.join(__dirname,'../shared/assistant.js');
vm.runInNewContext(fs.readFileSync(file,'utf8'),sandbox,{filename:file});
const api=sandbox.window.CareGridDemoChat;
assert(api,'Assistant API should be initialized without a UI');
assert.equal(api.ROLES.length,8);
for (const role of ['membership','beneficiary','restaurant','sponsor']) assert(api.ROLES.includes(role));
assert.match(api.answer('How do NGO licenses work?','membership').text,/trial/i);
assert.match(api.answer('How do I upload a prescription?','beneficiary').text,/fictional/i);
assert.match(api.answer('How do I list surplus food?','restaurant').text,/listing/i);
assert.match(api.answer('How do I make a demo donation?','sponsor').text,/payment/i);
assert(api.getFaqs().length>=6);
assert.match(api.answer('How do I verify a digital id card?','pharmacy').text,/DEMO/i);
assert.match(api.answer('How to register a beneficiary?','ngo').text,/Walk-in Registration/);
assert.match(api.answer('What is the remaining live subsidy balance?','lab').text,/No|not|demo|fictional/i);
assert.match(api.answer('What is the secret key?','lab').text,/do not share/i);
const edited=api.getFaqs();
edited.unshift({id:'unit-test-1',question:'What is a unit-check?',answer:'Custom answer via Admin.',keywords:'unit-check',roles:['admin'],enabled:true,category:'Unit test'});
assert(api.setFaqs(edited));
assert.equal(api.answer('unit-check','admin').text,'Custom answer via Admin.');
assert.notEqual(api.answer('unit-check','ngo').text,'Custom answer via Admin.');
assert(api.setCriteria({...api.getCriteria(),minimumMatches:3}));
assert.notEqual(api.answer('unit-check','admin').text,'Custom answer via Admin.');
assert(api.setCriteria({...api.getCriteria(),minimumMatches:1,retainHistory:true}));
api.storeTurn({role:'lab',sessionId:'test',question:'My CNIC is 35202-1234567-8',response:{text:'This is a demo',source:'Test'}});
assert.equal(api.getHistory().length,1);
assert.match(api.getHistory()[0].question,/redacted CNIC/);
assert(!api.getHistory()[0].question.includes('1234567'));
assert(api.clearHistory());
assert.equal(api.getHistory().length,0);
api.resetDefaults();
assert(api.getFaqs().length>=6);
console.log('CareGrid assistant API: all role, FAQ, policy, redaction, history tests passed.');
