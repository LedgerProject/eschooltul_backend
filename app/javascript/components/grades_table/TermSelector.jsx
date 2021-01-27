import React from 'react';

const TermSelector = (props) => (
  <div className="">
    <label htmlFor="all">
      All
      <input type="radio" name="term" id="all" value={-1} onChange={props.onSelectTerm}/>
    </label>
            
    {props.terms.map((term, index) => (
      <label key={term.id} htmlFor={term.name}>
        {term.name}
        <input type="radio" name="term" id={term.name} value={index} onChange={props.onSelectTerm}/>
      </label>
    ))}
  </div>
);

export default TermSelector;
