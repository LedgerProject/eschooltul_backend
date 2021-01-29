import React from 'react';
// TODO: Lessons without term when using terms
const Column = (props) => (
  <div className={`flex flex-col ${props.className} w-32`}>
    <p className="text-center">{props.name}</p>
  </div>
);

const WithoutTerms = (props) => (
  <>
    {props.lessons.map((lesson) => (
      <Column 
        key={lesson.lesson.id} 
        name={lesson.lesson.name} 
        className="justify-center" 
      />
    ))}
    <Column name="Course" className="justify-center" />
  </>
);

const AllTerms = (props) => (
  <>
    {props.terms.map((term) => (
      <div key={term.term.id} className="border-r border-gray-200 flex flex-col justify-between">
        <p className="text-center mb-1 border-b border-gray-200">{term.term.name}</p>
        <div className="flex items-stretch">
          {term.lessons.map((lesson) => (
            <Column 
              key={lesson.lesson.id} 
              name={lesson.lesson.name} 
              className="justify-end" 
            />
          ))}
          <Column name="Term" className="justify-end" />
        </div>
      </div>
    ))}
    <Column name="Course" className="justify-center" />
  </>
);

const OneTerm = (props) => (
  <>
    {props.lessons.map((lesson) => (
      <Column 
        key={lesson.lesson.id} 
        name={lesson.lesson.name} 
        className="justify-center" 
      />
    ))}
    <Column name="Term" className="justify-center" />
  </>
);


const StudentTableHeader = (props) => (
  <div className="grades-table-header">
    <div className="flex flex-col justify-center w-40 border-r border-gray-200">
      <p className="text-lg text-center">
        Student
      </p>
    </div>
    {props.isUndefined && (
      <WithoutTerms lessons={props.courseMember.lessons} />
    )}
    {!props.isUndefined && props.isAllTermsSelected && (
      <AllTerms terms={props.courseMember.terms} />
    )}
    {!props.isUndefined && !props.isAllTermsSelected && (
      <OneTerm lessons={props.courseMember.terms[0].lessons} />
    )}
  </div>
);

export default StudentTableHeader;
