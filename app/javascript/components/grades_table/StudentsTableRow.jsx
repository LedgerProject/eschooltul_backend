import React, { Fragment } from 'react';

const fieldToString = (field) => {
  if (_.isNil(field)){
    return ""
  }

  return field;
}

const studentFullName = (student) => (
  `${fieldToString(student.name)} ${fieldToString(student.first_surname)} ${fieldToString(student.second_surname)}`
);

const InputColumn = (props) => (
  <div className={`flex flex-col justify-center w-32 ${props.className}`}>
    <input type="text" className="w-16 h-8 mx-auto block" /*value={markValue(lesson.mark.value)} onChange={() => {}}*//>
  </div>
);

const WithoutTerms = (props) => (
  <>
    {props.lessons.map((lesson, index) => (
      <InputColumn key={lesson.lesson.id} />
    ))}
    <InputColumn />
  </>
);

const AllTerms = (props) => (
  <>
    {props.terms.map((term, index) => (
      <Fragment key={term.term.id}>
        {term.lessons.map((lesson, index) => (
          <InputColumn key={lesson.lesson.id} />
        ))}
        <InputColumn key={term.term.id} className="border-r border-gray-200" />
      </Fragment>
    ))}
    <InputColumn />
  </>
);

const OneTerm = (props) => (
  <>
    {props.term.lessons.map((lesson, index) => (
      <InputColumn key={lesson.lesson.id} />
    ))}
    <InputColumn />
  </>
);

const StudentTableRow = (props) => (
  <div className="grades-table-row">
    <div className="flex flex-col justify-center w-40 border-r border-gray-200">
      <p className="text-lg font-semibold tracking-tight">
        {studentFullName(props.courseMember.student)}
      </p>
    </div>
    {props.isUndefined && (
      <WithoutTerms lessons={props.courseMember.lessons} />
    )}

    {!props.isUndefined && props.isAllTermsSelected && (
      <AllTerms terms={props.courseMember.terms} />
    )}

    {!props.isUndefined && !props.isAllTermsSelected && (
      <OneTerm term={props.courseMember.terms[0]} />
    )}

  </div>
);

export default StudentTableRow;
