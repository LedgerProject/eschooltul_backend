import React from 'react';
import I18n from '../../i18n-js/index.js.erb';

const EmptyStudents = () => (
  <div className="flex flex-col justify-center items-center my-5">
    <p className="text-center text-lg mb-4">
      {I18n.t('grades.empty')}
    </p>
  </div>
);

export default EmptyStudents;
