import React from 'react';
import _ from 'lodash';
import SingleHeader from './header/SingleHeader';
import FullHeader from './header/FullHeader';

const TableHeader = ({courseMember, isUndefined, isAllTermsSelected}) => (
  <div className="grades-table-header">
    <div className="flex flex-col justify-center w-40 border-r border-gray-200">
      <p className="text-lg text-center">
        Student
      </p>
    </div>
    { isUndefined && (
      <SingleHeader 
        courseLessons={courseMember.lessons} 
        lastColumnName="Course"
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
        lastColumnName="Term"
      /> 
    )}
  </div>
);

export default TableHeader;
