import React from 'react';
import _ from 'lodash/fp';
import Column from './Column';

const TermsRow = ({ courseTerms, courseLessons, lastColumnName }) => (
  <>
    {_.map((courseTerm) => (
      <Column
        key={courseTerm.term.id}
        name={courseTerm.term.name}
        className="justify-center"
      />
    ))(courseTerms)}
    {_.map((courseLesson) => (
      <Column
        key={courseLesson.lesson.id}
        name={courseLesson.lesson.name}
        className="justify-center"
      />
    ))(courseLessons)}
    <Column name={lastColumnName} className="justify-center" />
  </>
);

export default TermsRow;
