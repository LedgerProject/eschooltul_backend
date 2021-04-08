import React from 'react';
import I18n from '../../i18n-js/index.js.erb';

const EmptyStudents = () => (
  <>
    <h1 className="text-2xl md:text-5xl font-bold tracking-tighter">{I18n.t('grades.title')}</h1>
    <p className="text-gray-400 tracking-widest mb-2">{I18n.t('grades.subtitle')}</p>
    <div className="flex flex-col justify-center items-center my-5">
      <p className="text-center text-lg mb-4">
        {I18n.t('grades.empty')}
      </p>
    </div>
  </>
);

export default EmptyStudents;
