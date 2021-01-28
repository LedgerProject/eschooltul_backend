import React from 'react';
import _ from 'lodash/fp';

const isSelected = (selectedTerm, term_id = null) => {
  if(_.isUndefined(selectedTerm)){
    return false;
  }

  if(_.isEqual(selectedTerm.id, term_id)){
    return true;
  }

  return false;
};

const TermSelector = (props) => (
  <div className="mb-2 md:mb-4">
    <label 
      htmlFor="all" 
      className={`term-selector ${_.isUndefined(props.selectedTerm) ? "selected" : "" }`}
    >
      All
      <input 
        type="radio" 
        name="term" 
        id="all" 
        value={-1} 
        className="hidden"
        onChange={props.onSelectTerm}
        checked={_.isUndefined(props.selectedTerm)}
      />
    </label>
    {props.terms.map((term, index) => (
      <label 
        key={term.id} 
        htmlFor={term.name} 
        className={`term-selector ${isSelected(props.selectedTerm, term.id) ? "selected" : ""}`}
      >
        {term.name}
        <input 
          type="radio" 
          name="term" 
          id={term.name} 
          value={index} 
          className="hidden"
          onChange={props.onSelectTerm}
          checked={isSelected(props.selectedTerm, term.id)}
        />
      </label>
    ))}
  </div>
);

export default TermSelector;
