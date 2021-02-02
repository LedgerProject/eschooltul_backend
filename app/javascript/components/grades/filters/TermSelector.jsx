import React from 'react';
import _ from 'lodash/fp';

const isSelected = (selectedTerm, termID = null) => (
  _.isEqual(selectedTerm.id, termID) ? true : false
);

const RadioButton = ({id, text, value, onChange, checked}) => (
  <label htmlFor={id} className={`term-selector ${checked ? "selected" : "" }`}>
    {text}
    <input 
      type="radio" 
      name="term" 
      id={id} 
      value={value} 
      className="hidden"
      onChange={onChange}
      checked={checked}
    />
  </label>
);

const TermSelector = ({terms, selectedTerm, onSelectedTerm}) => (
  <div className="mb-2 md:mb-4">
    <RadioButton 
      id="all"
      text="All"
      value={undefined}
      onChange={onSelectedTerm}
      checked={_.isUndefined(selectedTerm)}
    />
    {terms.map((term, index) => (
      <RadioButton 
        key={term.id}
        id={term.name}
        text={term.name}
        value={index}
        onChange={onSelectedTerm}
        checked={!_.isUndefined(selectedTerm) && isSelected(selectedTerm, term.id)}
      />
    ))}
  </div>
);

export default TermSelector;
