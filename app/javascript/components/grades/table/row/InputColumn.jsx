import React from 'react';
import _ from 'lodash/fp';

const replaceDots = _.replace(',', '.');

const InputColumn = ({ className, mark, onValueChange }) => (
  <div className={`flex flex-col justify-center w-32 max-w-32 min-w-32 ${className}`}>
    <input
      type="text"
      maxLength={4}
      className="w-16 h-8 mx-auto block text-center"
      value={_.toString(mark.value)}
      onChange={(e) => {
        onValueChange({
          id: mark.id,
          remarkable_id: mark.remarkable_id,
          remarkable_type: mark.remarkable_type,
          student_id: mark.student_id,
          value: replaceDots(e.target.value),
        });
      }}
    />
  </div>
);

export default InputColumn;
