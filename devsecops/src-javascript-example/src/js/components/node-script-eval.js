const isScript = (node) => node.tagName === 'SCRIPT';

const cloneScript = (node) => {
  const script = document.createElement('script');

  script.text = node.innerHTML;

  for (let i = node.attributes.length - 1; i >= 0; i--) {
    script.setAttribute(node.attributes[i].name, node.attributes[i].value);
  }

  return script;
};


const replaceScriptRecursive = (node) => {
  if (isScript(node) === true) {
    node.parentNode.replaceChild(cloneScript(node), node);
  } else {
    let i = 0;
    const children = node.childNodes;

    while (i < children.length) {
      replaceScriptRecursive(children[i++]);
    }
  }

  return node;
};

export default replaceScriptRecursive;
