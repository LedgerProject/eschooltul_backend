import React from 'react';
import _ from 'lodash/fp';
import Column from './Column';

const SingleHeader = ({courseLessons, lastColumnName}) => (
  <>
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

export default SingleHeader;
