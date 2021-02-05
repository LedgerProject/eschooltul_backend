import React from 'react';
import SingleHeader from './header/SingleHeader';
import FullHeader from './header/FullHeader';
import I18n from '../../../i18n-js/index.js.erb';

const TableHeader = ({ courseMember, isUndefined, isAllTermsSelected }) => (
  <div className="grades-table-header">
    <div className="flex flex-col justify-center w-40 border-r border-gray-200">
      <p className="text-lg text-center">
        {I18n.t('grades.student')}
      </p>
    </div>
    { isUndefined && (
      <SingleHeader
        courseLessons={courseMember.lessons}
        lastColumnName={I18n.t('grades.course')}
      />
    )}
    {!isUndefined && isAllTermsSelected && (
      <FullHeader
        courseTerms={courseMember.terms}
        courseLessons={courseMember.lessons}
      />
    )}
    {!isUndefined && !isAllTermsSelected && (
      <SingleHeader
        courseLessons={courseMember.terms[0].lessons}
        lastColumnName={I18n.t('grades.term')}
      />
    )}
  </div>
);

export default TableHeader;
