(() => {
  'use strict';
  const api=window.CareGridDemoChat;
  if(!api)return;
  const $=id=>document.getElementById(id);
  const notice=text=>{const el=$('admin-notice');el.textContent=text;clearTimeout(notice.t);notice.t=setTimeout(()=>el.textContent='',3100);};
  const dialog=$('faq-dialog'),form=$('faq-form');
  const count=()=>{const a=api.getFaqs().filter(x=>x.enabled);$('faq-count').textContent=a.length;$('chat-count').textContent=api.getHistory().length;};
  function renderFaqs(){
    const container=$('faq-list');container.replaceChildren();
    for(const faq of api.getFaqs()){
      const row=document.createElement('article');row.className='cg-faq-row'+(faq.enabled?'':' off');
      const info=document.createElement('div');
      const title=document.createElement('h3');title.textContent=faq.question;
      const para=document.createElement('p');para.textContent=faq.answer;
      const meta=document.createElement('small');meta.textContent=faq.category+' · '+faq.roles.map(x=>api.ROLE_LABELS[x]).join(', ')+' · '+(faq.enabled?'Enabled':'Disabled');
      info.append(title,para,meta);
      const actions=document.createElement('div');actions.className='cg-faq-actions';
      const edit=document.createElement('button');edit.type='button';edit.textContent='Edit';edit.addEventListener('click',()=>openForm(faq));
      const toggle=document.createElement('button');toggle.type='button';toggle.textContent=faq.enabled?'Disable':'Enable';toggle.addEventListener('click',()=>{
        const faqs=api.getFaqs();const item=faqs.find(x=>x.id===faq.id);if(item){item.enabled=!item.enabled;api.setFaqs(faqs);renderAll();}});
      const del=document.createElement('button');del.type='button';del.textContent='Delete';del.addEventListener('click',()=>{
        if(confirm('Delete this demo FAQ?')){api.setFaqs(api.getFaqs().filter(x=>x.id!==faq.id));renderAll();}});
      actions.append(edit,toggle,del);row.append(info,actions);container.appendChild(row);
    }
    if(!container.children.length){const p=document.createElement('p');p.textContent='No FAQs. Add a question to start.';container.appendChild(p);}
  }
  function openForm(faq){
    form.reset();
    $('dialog-heading').textContent=faq?'Edit approved question':'Add approved question';
    form.elements.id.value=faq?.id||'';
    form.elements.question.value=faq?.question||'';
    form.elements.answer.value=faq?.answer||'';
    form.elements.keywords.value=faq?.keywords||'';
    form.elements.category.value=faq?.category||'General';
    form.elements.enabled.checked=faq?.enabled!==false;
    form.querySelectorAll('input[name="roles"]').forEach(input=>input.checked=faq?faq.roles.includes(input.value):true);
    dialog.showModal();form.elements.question.focus();
  }
  form.addEventListener('submit',e=>{
    e.preventDefault();
    const fd=new FormData(form),roles=fd.getAll('roles').map(String);
    if(!roles.length){notice('Select at least one role.');return;}
    const faq={id:String(fd.get('id')||'faq-'+Date.now()+'-'+Math.random().toString(36).slice(2,5)),question:String(fd.get('question')).trim(),answer:String(fd.get('answer')).trim(),keywords:String(fd.get('keywords')).trim(),category:String(fd.get('category')).trim(),roles,enabled:fd.has('enabled')};
    if(!faq.question||!faq.answer||!faq.keywords){notice('Question, answer and keywords are required.');return;}
    const a=api.getFaqs(),index=a.findIndex(x=>x.id===faq.id);if(index>=0)a[index]=faq;else a.unshift(faq);
    if(!api.setFaqs(a)){notice('Unable to save browser settings.');return;}
    dialog.close();renderAll();notice('Demo question saved.');
  });
  $('new-faq').addEventListener('click',()=>openForm());
  $('close-faq').addEventListener('click',()=>dialog.close());
  const criteriaForm=$('criteria-form');
  function fillCriteria(){
    const c=api.getCriteria();
    for(const k of ['minimumMatches','maxQuestionLength','prohibited','fallback'])criteriaForm.elements[k].value=c[k];
    criteriaForm.elements.retainHistory.checked=!!c.retainHistory;
  }
  criteriaForm.addEventListener('submit',e=>{
    e.preventDefault();const f=criteriaForm.elements;
    const good=api.setCriteria({minimumMatches:Number(f.minimumMatches.value),maxQuestionLength:Number(f.maxQuestionLength.value),prohibited:f.prohibited.value.trim(),fallback:f.fallback.value.trim(),retainHistory:f.retainHistory.checked});
    if(good)notice('Response criteria saved locally.');else notice('Browser storage unavailable.');
  });
  function renderHistory(){
    const role=$('history-role').value,container=$('history-body');
    container.replaceChildren();
    const logs=api.getHistory().filter(x=>role==='all'||x.role===role).reverse();
    for(const h of logs){
      const tr=document.createElement('tr');
      const date=document.createElement('td');date.textContent=new Date(h.date).toLocaleString();
      const kind=document.createElement('td');kind.textContent=api.ROLE_LABELS[h.role]||h.role;
      const question=document.createElement('td');question.textContent=h.question;
      const answer=document.createElement('td');answer.textContent=h.answer;
      const source=document.createElement('small');source.textContent=h.source;answer.appendChild(source);
      tr.append(date,kind,question,answer);container.appendChild(tr);
    }
    if(!logs.length){const tr=document.createElement('tr'),td=document.createElement('td');td.colSpan=4;td.textContent='No demo conversations for the selected portal.';tr.appendChild(td);container.appendChild(tr);}
  }
  $('history-role').addEventListener('change',renderHistory);
  $('clear-history').addEventListener('click',()=>{
    if(confirm('Clear the stored demo conversation history in this browser?')){api.clearHistory();renderAll();notice('Local demo history cleared.');}
  });
  $('export-history').addEventListener('click',()=>{
    const text=JSON.stringify({exportedAt:new Date().toISOString(),scope:'Browser-local sanitized DEMO history only',history:api.getHistory()},null,2);
    const blob=new Blob([text],{type:'application/json'}),url=URL.createObjectURL(blob);
    const a=document.createElement('a');a.href=url;a.download='caregrid-demo-chat-history.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
  });
  function renderAll(){renderFaqs();renderHistory();count();}
  window.addEventListener('storage',renderAll);
  fillCriteria();renderAll();
})();
