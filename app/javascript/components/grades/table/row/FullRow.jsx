import React, { Fragment } from 'react';
import _ from 'lodash/fp';
import InputColumn from './InputColumn';

const FullRow = ({
  courseTerms,
  courseMark,
  onValueChange,
  courseLessons,
}) => (
  <>
    {_.map((courseTerm) => (
      <Fragment key={courseTerm.term.id}>
        {_.map((courseLesson) => (
          <InputColumn
            key={courseLesson.lesson.id}
            mark={courseLesson.mark}
            onValueChange={onValueChange}
          />
        ))(courseTerm.lessons)}
        <InputColumn
          key={courseTerm.term.id}
          className="border-r border-gray-200"
          mark={courseTerm.termMark}
          onValueChange={onValueChange}
        />
      </Fragment>
    ))(courseTerms)}
    {_.map((courseLesson) => (
      <InputColumn
        key={courseLesson.lesson.id}
        mark={courseLesson.mark}
        onValueChange={onValueChange}
      />
    ))(courseLessons)}
    <InputColumn
      mark={courseMark}
      onValueChange={onValueChange}
    />
  </>
);

export default FullRow;
