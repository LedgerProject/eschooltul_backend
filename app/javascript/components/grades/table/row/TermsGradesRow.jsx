import React from 'react';
import _ from 'lodash/fp';
import InputColumn from './InputColumn';

const TermsGradesRow = ({
  courseTerms, courseLessons, mark, onValueChange,
}) => (
  <>
    {_.map((courseTerm) => (
      <InputColumn
        key={courseTerm.term.id}
        mark={courseTerm.termMark}
        onValueChange={onValueChange}
      />
    ))(courseTerms)}
    {_.map((courseLesson) => (
      <InputColumn
        key={courseLesson.lesson.id}
        mark={courseLesson.mark}
        onValueChange={onValueChange}
      />
    ))(courseLessons)}
    <InputColumn
      mark={mark}
      onValueChange={onValueChange}
    />
  </>
);

export default TermsGradesRow;
