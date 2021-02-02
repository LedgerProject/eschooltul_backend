import React from 'react';
import _ from 'lodash/fp';
import Column from './Column';

const FullHeader = ({courseTerms, courseLessons}) => (
  <>
    {_.map((courseTerm) => (
      <div key={courseTerm.term.id} className="border-r border-gray-200 flex flex-col justify-between">
        <p className="text-center mb-1 border-b border-gray-200">{courseTerm.term.name}</p>
        <div className="flex items-stretch">
          {_.map((courseLesson) => (
            <Column 
              key={courseLesson.lesson.id} 
              name={courseLesson.lesson.name} 
              className="justify-end" 
            />
          ))(courseTerm.lessons)}
          <Column name="Term" className="justify-end" />
        </div>
      </div>
    ))(courseTerms)}
    {_.map((courseLesson) => (
      <Column 
        key={courseLesson.lesson.id}
        name={courseLesson.lesson.name}
        className="justify-center"
      />
    ))(courseLessons)}
    <Column name="Course" className="justify-center" />
  </>
);

export default FullHeader;
