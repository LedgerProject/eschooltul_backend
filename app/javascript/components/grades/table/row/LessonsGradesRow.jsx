import React from 'react';
import _ from 'lodash/fp';
import InputColumn from './InputColumn';

const LessonsGradesRow = ({ courseLessons, mark, onValueChange }) => (
  <>
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

export default LessonsGradesRow;
