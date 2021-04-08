import React from 'react';
import _ from 'lodash';
import I18n from '../../../i18n-js/index.js.erb';
import LessonsRow from './header/LessonsRow';
import TermsRow from './header/TermsRow';

const TableHeader = ({ courseMember, selectedTerm }) => (
  <div className="grades-table-header">
    <div className="flex flex-col justify-center w-52 max-w-52 min-w-52 border-r border-gray-200">
      <p className="text-lg text-center">
        {I18n.t('grades.student')}
      </p>
    </div>
    {_.isUndefined(courseMember.terms) && (
      <LessonsRow
        courseLessons={courseMember.lessons}
        lastColumnName={I18n.t('grades.course')}
      />
    )}
    {(!_.isUndefined(courseMember.terms) && !_.isUndefined(selectedTerm)) && (
      <LessonsRow
        courseLessons={courseMember.terms[0].lessons}
        lastColumnName={I18n.t('grades.term')}
      />
    )}
    {(!_.isUndefined(courseMember.terms) && _.isUndefined(selectedTerm)) && (
      <TermsRow
        courseTerms={courseMember.terms}
        courseLessons={courseMember.lessons}
        lastColumnName={I18n.t('grades.course')}
      />
    )}
  </div>
);

export default TableHeader;
